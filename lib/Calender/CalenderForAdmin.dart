import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Administrator/Administator_Agreement/Sub/All_data_details_page.dart';
import 'package:verify_feild_worker/Administrator/New_TenandDemand/Admin_demand_detail.dart';
import '../Administrator/Admin_future _property/Admin_under_flats.dart';
import '../Administrator/Admin_future _property/Future_Property_Details.dart';
import '../Administrator/Administater_Realestate_Details.dart';
import '../Administrator/Administator_Agreement/Admin_Agreement_details.dart';
import '../Administrator/Administator_Agreement/Sub/Accepted_details.dart';
import '../Upcoming/Upcoming_details.dart';
import 'CalenderForFieldWorker.dart';


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

  // OWNER
  final String ownerName;
  final String ownerMobile;
  final String ownerAadhar;
  final String ownerRelation;
  final String ownerRelationName;
  final String ownerPermanentAddress;

  // TENANT
  final String tenantName;
  final String tenantMobile;
  final String tenantAadhar;
  final String tenantRelation;
  final String tenantRelationName;
  final String tenantPermanentAddress;
  final String tenantImage;

  // PROPERTY & AGREEMENT
  final String rentedAddress;
  final String monthlyRent;
  final String securityAmount;
  final String meter;
  final String maintenance;
  final String shiftingDate;
  final String bhk;
  final String floor;
  final String parking;
  final String agreementType;
  final String status;
  final String currentDate;
  final String propertyId;

  // FIELD WORKER
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  // DOCUMENTS
  final String? agreementPdf;
  final String ownerAadharFront;
  final String ownerAadharBack;
  final String tenantAadharFront;
  final String tenantAadharBack;

  AgreementTask({
    required this.id,

    required this.ownerName,
    required this.ownerMobile,
    required this.ownerAadhar,
    required this.ownerRelation,
    required this.ownerRelationName,
    required this.ownerPermanentAddress,

    required this.tenantName,
    required this.tenantMobile,
    required this.tenantAadhar,
    required this.tenantRelation,
    required this.tenantRelationName,
    required this.tenantPermanentAddress,
    required this.tenantImage,

    required this.rentedAddress,
    required this.monthlyRent,
    required this.securityAmount,
    required this.meter,
    required this.maintenance,
    required this.shiftingDate,
    required this.bhk,
    required this.floor,
    required this.parking,
    required this.agreementType,
    required this.status,
    required this.currentDate,
    required this.propertyId,

    required this.fieldWorkerName,
    required this.fieldWorkerNumber,

    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    this.agreementPdf,
  });

  factory AgreementTask.fromJson(Map<String, dynamic> json) {
    return AgreementTask(
      id: (json['id'] as num?)?.toInt() ?? 0,

      // OWNER
      ownerName: json['owner_name'] ?? '',
      ownerMobile: json['owner_mobile_no'] ?? '',
      ownerAadhar: json['owner_addhar_no'] ?? '',
      ownerRelation: json['owner_relation'] ?? '',
      ownerRelationName: json['relation_person_name_owner'] ?? '',
      ownerPermanentAddress: json['parmanent_addresss_owner'] ?? '',

      // TENANT
      tenantName: json['tenant_name'] ?? '',
      tenantMobile: json['tenant_mobile_no'] ?? '',
      tenantAadhar: json['tenant_addhar_no'] ?? '',
      tenantRelation: json['tenant_relation'] ?? '',
      tenantRelationName: json['relation_person_name_tenant'] ?? '',
      tenantPermanentAddress: json['permanent_address_tenant'] ?? '',
      tenantImage: json['tenant_image'] ?? '',

      // PROPERTY & AGREEMENT
      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      securityAmount: json['securitys'] ?? '',
      meter: json['meter'] ?? '',
      maintenance: json['maintaince'] ?? '',
      shiftingDate: json['shifting_date'] is Map
          ? json['shifting_date']['date'] ?? ''
          : json['shifting_date']?.toString() ?? '',

      currentDate: json['current_dates'] is Map
          ? json['current_dates']['date'] ?? ''
          : json['current_dates']?.toString() ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      parking: json['parking'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      status: json['status'] ?? '',
      propertyId: json['property_id'] ?? '',

      // FIELD WORKER
      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',

      // DOCUMENTS
      ownerAadharFront: json['owner_aadhar_front'] ?? '',
      ownerAadharBack: json['owner_aadhar_back'] ?? '',
      tenantAadharFront: json['tenant_aadhar_front'] ?? '',
      tenantAadharBack: json['tenant_aadhar_back'] ?? '',
      agreementPdf: json['agreement_pdf'],
    );
  }
}
/// -------- ADD FLAT IN FUTURE PROPERTY MODEL --------
class AddFlatResponse {
  final String status;
  final List<AdminAddFlat> data;

  AddFlatResponse({required this.status, required this.data});

  factory AddFlatResponse.fromJson(Map<String, dynamic> json) {
    return AddFlatResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AdminAddFlat.fromJson(e))
          .toList() ??
          [],
    );
  }

  static AddFlatResponse fromRawJson(String str) =>
      AddFlatResponse.fromJson(json.decode(str));
}

class AdminAddFlat {
  final int pId;
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
  final String field_warkar_name;
  final String careTakerNumber;
  final String datesForRightAvailable;
  final String subId;

  AdminAddFlat({
    required this.pId,
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
    required this.field_warkar_name,
    required this.careTakerNumber,
    required this.datesForRightAvailable,
    required this.subId,
  });

  factory AdminAddFlat.fromJson(Map<String, dynamic> json) {
    return AdminAddFlat(
      pId: (json['P_id'] as num?)?.toInt() ?? 0,

      propertyPhoto: json['property_photo']?.toString() ?? '',
      locations: json['locations']?.toString() ?? '',
      flatNumber: json['Flat_number']?.toString() ?? '',
      buyRent: json['Buy_Rent']?.toString() ?? '',
      residenceCommercial:
      json['Residence_Commercial']?.toString() ?? '',
      apartmentName: json['Apartment_name']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      showPrice: json['show_Price']?.toString() ?? '',
      floor: json['Floor_']?.toString() ?? '',
      liveUnlive: json['live_unlive']?.toString() ?? '',

      careTakerName:
      json['care_taker_name']?.toString() ?? '',
      careTakerNumber:
      json['care_taker_number']?.toString() ?? '',
      field_warkar_name:
      json['field_warkar_name']?.toString() ?? '',

      /// ⚠️ backend typo handled safely
      datesForRightAvailable:
      json['dates_for_right_avaiable']?.toString() ?? '',

      subId: json['subid']?.toString() ?? '',
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

class AdminAcceptedAgreementResponse {
  final String status;
  final List<AdminAcceptedAgreement> data;

  AdminAcceptedAgreementResponse({
    required this.status,
    required this.data,
  });

  factory AdminAcceptedAgreementResponse.fromJson(Map<String, dynamic> json) {
    return AdminAcceptedAgreementResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AdminAcceptedAgreement.fromJson(e))
          .toList() ??
          [],
    );
  }

  static AdminAcceptedAgreementResponse fromRawJson(String str) =>
      AdminAcceptedAgreementResponse.fromJson(json.decode(str));
}

class AdminAcceptedAgreement {
  final int id;
  final String ownerName;
  final String tenantName;
  final String rentedAddress;
  final String monthlyRent;
  final String bhk;
  final String floor;
  final String agreementType;
  final String fieldWorkerName;
  final String status;

  AdminAcceptedAgreement({
    required this.id,
    required this.ownerName,
    required this.tenantName,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.bhk,
    required this.floor,
    required this.agreementType,
    required this.fieldWorkerName,
    required this.status,
  });

  factory AdminAcceptedAgreement.fromJson(Map<String, dynamic> json) {
    return AdminAcceptedAgreement(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ownerName: json['owner_name'] ?? '',
      tenantName: json['tenant_name'] ?? '',
      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      status: "Accepted",
    );
  }
}

class AdminPendingAgreementResponse {
  final String status;
  final List<AdminPendingAgreement> data;

  AdminPendingAgreementResponse({
    required this.status,
    required this.data,
  });

  factory AdminPendingAgreementResponse.fromJson(Map<String, dynamic> json) {
    return AdminPendingAgreementResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AdminPendingAgreement.fromJson(e))
          .toList() ??
          [],
    );
  }

  static AdminPendingAgreementResponse fromRawJson(String str) =>
      AdminPendingAgreementResponse.fromJson(json.decode(str));
}

class AdminPendingAgreement {
  final int id;

  // OWNER
  final String ownerName;
  final String ownerRelation;
  final String ownerRelationPerson;
  final String ownerPermanentAddress;
  final String ownerMobile;
  final String ownerAadhar;

  // TENANT
  final String tenantName;
  final String tenantRelation;
  final String tenantRelationPerson;
  final String tenantPermanentAddress;
  final String tenantMobile;
  final String tenantAadhar;
  final String tenantImage;

  // AGREEMENT
  final String rentedAddress;
  final String monthlyRent;
  final String security;
  final String meter;
  final String maintenance;
  final String shiftingDate;
  final String bhk;
  final String floor;
  final String parking;
  final String agreementType;
  final String status;
  final String currentDate;

  // FIELD WORKER
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  AdminPendingAgreement({
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
    required this.tenantImage,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.security,
    required this.meter,
    required this.maintenance,
    required this.shiftingDate,
    required this.bhk,
    required this.floor,
    required this.parking,
    required this.agreementType,
    required this.status,
    required this.currentDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
  });

  factory AdminPendingAgreement.fromJson(Map<String, dynamic> json) {
    return AdminPendingAgreement(
      id: (json['id'] as num?)?.toInt() ?? 0,

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
      tenantImage: json['tenant_image'] ?? '',

      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      security: json['securitys'] ?? '',
      meter: json['meter'] ?? '',
      maintenance: json['maintaince'] ?? '',
      shiftingDate: json['shifting_date'] is Map
          ? json['shifting_date']['date'] ?? ''
          : json['shifting_date']?.toString() ?? '',

      currentDate: json['current_dates'] is Map
          ? json['current_dates']['date'] ?? ''
          : json['current_dates']?.toString() ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      parking: json['parking'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      status: json['status'] ?? 'pending',

      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',
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

class BuildingCallingResponse {
  final String status;
  final List<BuildingCalling> data;

  BuildingCallingResponse({required this.status, required this.data});

  factory BuildingCallingResponse.fromJson(Map<String, dynamic> json) {
    return BuildingCallingResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BuildingCalling.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class BuildingCalling {
  final int id;
  final String message;
  final String date;
  final String time;
  final String subid;
  final String nextCallingDate;
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  BuildingCalling({
    required this.id,
    required this.message,
    required this.date,
    required this.time,
    required this.subid,
    required this.nextCallingDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
  });

  factory BuildingCalling.fromJson(Map<String, dynamic> json) {
    return BuildingCalling(
      id: (json['id'] as num?)?.toInt() ?? 0,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      subid: json['subid'] ?? '',
      nextCallingDate: json['next_calling_date'] ?? '',
      fieldWorkerName: json['fieldworkar_name'] ?? '',
      fieldWorkerNumber: json['fieldworkar_number'] ?? '',
    );
  }
}

/// -------- MAIN PAGE --------
class CalendarTaskPageForAdmin extends StatefulWidget {
  const CalendarTaskPageForAdmin({super.key});

  @override
  State<CalendarTaskPageForAdmin> createState() => _CalendarTaskPageForAdminState();
}

class _CalendarTaskPageForAdminState extends State<CalendarTaskPageForAdmin> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = false;
  List<AgreementTask> _agreements = [];
  List<FutureProperty> _futureProperties = [];
  Map<DateTime, bool> _eventDays = {};
  List<AdminAcceptedAgreement> _acceptedAgreements = [];
  List<AdminPendingAgreement> _pendingAgreements = [];

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedYear = _focusedDay.year;
    _selectedMonth = _focusedDay.month;

    _initUserAndFetch();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMonthlyEvents(_selectedYear, _selectedMonth);
    });
  }

  Future<void> _initUserAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    final storedFAadharCard = prefs.getString('post');

    setState(() {
      userName = storedName;
      userNumber = storedNumber;
      userStoredFAadharCard = storedFAadharCard;


    });

    if (userNumber != null && userNumber!.isNotEmpty) {
      await _fetchData(_focusedDay);
    } else {
      debugPrint("⚠️ userNumber not found in SharedPreferences");
    }
  }
  String normalizeFW(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z ]'), '') // remove symbols
        .replaceAll('khan', '')             // remove surname
        .trim()
        .split(' ')
        .first;                             // take first name only
  }

  bool _canShowForSubAdmin(String? fieldWorkerName) {
    final role = (userStoredFAadharCard ?? '').toLowerCase().trim();
    final uname = (userName ?? '').toLowerCase().trim();

    // Administrator → ALL DATA
    if (role == 'administrator') return true;

    if (fieldWorkerName == null || fieldWorkerName.trim().isEmpty) {
      return false;
    }

    final fw = normalizeFW(fieldWorkerName);

    const shivaniWorkers = {'abhay', 'manish'};
    const saurabhWorkers = {'faizan', 'ravi', 'sumit', 'avjit'};

    if (uname == 'shivani' || uname == 'shivani joshi') {
      return shivaniWorkers.contains(fw);
    }

    if (uname == 'saurabh' || uname == 'saurabh yadav') {
      return saurabhWorkers.contains(fw);
    }

    return false;
  }

  String? userName;
  String? userNumber;
  String? userStoredFAadharCard;

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    final storedFAadharCard = prefs.getString('post');

    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
        userStoredFAadharCard = storedFAadharCard;
      });
    }
  }

  String _monthName(int m) => _months[m - 1];
  List<WebsiteVisit> _websiteVisits = [];
  List<AdminAddFlat> _addFlats = [];
  List<AdminAcceptedAgreement> acceptedAgreements = [];
  List<TenantDemand> _adminTenantDemands = [];
  List<LiveFlat> _adminLiveProperties = [];
  List<BookedTenantVisit> _bookedTenantVisits = [];
  List<UpcomingFlat> _adminUpcomingFlats = [];
  List<BuildingCalling> _buildingCalls = [];

  Future<void> _fetchData(DateTime date) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    _agreements.clear();
    _acceptedAgreements.clear();
    _pendingAgreements.clear();
    _futureProperties.clear();
    _websiteVisits.clear();
    _addFlats.clear();
    _adminTenantDemands.clear();
    _adminLiveProperties.clear();
    _bookedTenantVisits.clear();
    _adminUpcomingFlats.clear();
    _buildingCalls.clear();

    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      // ===================== AGREEMENTS =====================
      final agreementRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_agreement_for_admin.php?current_dates=$formattedDate"));

      if (agreementRes.statusCode == 200 && agreementRes.body.isNotEmpty) {
        _agreements =
            AgreementTaskResponse.fromJson(jsonDecode(agreementRes.body)).data;

        _agreements = _agreements
            .where((e) => _canShowForSubAdmin(e.fieldWorkerName))
            .toList();
      }

      // ================= ACCEPTED AGREEMENTS =================
      final acceptedRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/accept_agreement_for_admin.php?current_dates=$formattedDate"));

      if (acceptedRes.statusCode == 200 && acceptedRes.body.isNotEmpty) {
        _acceptedAgreements =
            AdminAcceptedAgreementResponse.fromJson(jsonDecode(acceptedRes.body)).data;

        _acceptedAgreements = _acceptedAgreements
            .where((e) => _canShowForSubAdmin(e.fieldWorkerName))
            .toList();
      }

      // ================= PENDING AGREEMENTS =================
      final pendingRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/pending_agreement_for_admin.php?current_dates=$formattedDate"));

      if (pendingRes.statusCode == 200 && pendingRes.body.isNotEmpty) {
        _pendingAgreements =
            AdminPendingAgreementResponse.fromJson(jsonDecode(pendingRes.body)).data;

        _pendingAgreements = _pendingAgreements
            .where((e) => _canShowForSubAdmin(e.fieldWorkerName))
            .toList();
      }

      // ================= FUTURE PROPERTIES =================
      final futureRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_building_for_admin.php?current_date_=$formattedDate"));

      if (futureRes.statusCode == 200 && futureRes.body.isNotEmpty) {
        _futureProperties =
            FuturePropertyResponse.fromJson(jsonDecode(futureRes.body)).data;

        _futureProperties = _futureProperties
            .where((e) => _canShowForSubAdmin(e.fieldWorkerName))
            .toList();
      }

      // ================= ADD FLATS =================
      final addFlatRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/add_flat_in_future_property_for_admin.php?current_dates=$formattedDate"));

      if (addFlatRes.statusCode == 200 && addFlatRes.body.isNotEmpty) {
        _addFlats = AddFlatResponse.fromJson(jsonDecode(addFlatRes.body)).data;

        _addFlats = _addFlats
            .where((e) => _canShowForSubAdmin(e.field_warkar_name))
            .toList();
      }

      // ================= BOOKED TENANT VISITS =================
      final visitRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/book_visit_in_tenant_demand_for_admin.php?visiting_dates=$formattedDate"));

      if (visitRes.statusCode == 200 && visitRes.body.isNotEmpty) {
        final decoded = jsonDecode(visitRes.body);
        if (decoded['status'] == 'success') {
          _bookedTenantVisits =
              BookedTenantVisitResponse.fromJson(decoded).data;

          _bookedTenantVisits = _bookedTenantVisits
              .where((e) => _canShowForSubAdmin(e.assignedFieldWorkerName))
              .toList();
        }
      }

      // ================= WEBSITE VISITS =================
      final webRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/web_visit_for_admin.php?dates=$formattedDate"));

      if (webRes.statusCode == 200 && webRes.body.isNotEmpty) {
        _websiteVisits =
            WebsiteVisitResponse.fromJson(jsonDecode(webRes.body)).data;

        _websiteVisits = _websiteVisits
            .where((e) => _canShowForSubAdmin(e.fieldWorkerName))
            .toList();
      }

      // ================= TENANT DEMANDS =================
      final demandRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/tenant_demand_for_admin.php?Date=$formattedDate"));

      if (demandRes.statusCode == 200 && demandRes.body.isNotEmpty) {
        final decoded = jsonDecode(demandRes.body);
        if (decoded['status'] == 'success') {
          _adminTenantDemands =
              TenantDemandResponse.fromJson(decoded).data;

          _adminTenantDemands = _adminTenantDemands
              .where((e) => _canShowForSubAdmin(e.fieldWorkerName))
              .toList();
        }
      }

      // ================= UPCOMING FLATS =================
      final upcomingRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/upcomin_flat_for_admin.php?dates_for_right_avaiable=$formattedDate"));

      if (upcomingRes.statusCode == 200 && upcomingRes.body.isNotEmpty) {
        final decoded = jsonDecode(upcomingRes.body);
        if (decoded['status'] == 'success') {
          _adminUpcomingFlats =
              UpcomingFlatResponse.fromJson(decoded).data;

          _adminUpcomingFlats = _adminUpcomingFlats
              .where((e) => _canShowForSubAdmin(e.fieldWarkarName))
              .toList();
        }
      }

      // ================= LIVE PROPERTIES =================
      final liveRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/live_property_for_admin.php?date_for_target=$formattedDate"));

      if (liveRes.statusCode == 200 && liveRes.body.isNotEmpty) {
        final decoded = jsonDecode(liveRes.body);
        if (decoded['status'] == 'success') {
          _adminLiveProperties = (decoded['data'] as List)
              .map((e) => LiveFlat.fromJson(e))
              .toList();

          _adminLiveProperties = _adminLiveProperties
              .where((e) => _canShowForSubAdmin(e.fieldWarkarName))
              .toList();
        }
      }
// ================= BUILDING CALLING REMINDER =================
      final callingRes = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/building_calling_option_for_admin.php?next_calling_date=$formattedDate"
      ));

      if (callingRes.statusCode == 200 && callingRes.body.isNotEmpty) {
        final decoded = jsonDecode(callingRes.body);
        if (decoded['status'] == 'success') {
          _buildingCalls =
              BuildingCallingResponse.fromJson(decoded).data;

          _buildingCalls = _buildingCalls
              .where((e) => _canShowForSubAdmin(e.fieldWorkerName))
              .toList();
        }
      }

      // ================= FINAL DEDUP =================
      _agreements = {for (var a in _agreements) a.id: a}.values.toList();
      _acceptedAgreements =
          {for (var a in _acceptedAgreements) a.id: a}.values.toList();
      _pendingAgreements =
          {for (var p in _pendingAgreements) p.id: p}.values.toList();
      _adminTenantDemands =
          {for (var d in _adminTenantDemands) d.id: d}.values.toList();
      _addFlats = {for (var f in _addFlats) f.pId: f}.values.toList();
      _bookedTenantVisits =
          {for (var v in _bookedTenantVisits) v.id: v}.values.toList();
      _adminUpcomingFlats =
          {for (var f in _adminUpcomingFlats) f.propertyId: f}.values.toList();

    } catch (e, s) {
      debugPrint("❌ ADMIN FETCH ERROR: $e");
      debugPrintStack(stackTrace: s);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                Text(
                    "Select Month & Year",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor
                    )
                ),
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

                      // 🔥 FORCE CALENDAR PAGE UPDATE
                      _calendarKey = UniqueKey();
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

  Future<void> _fetchMonthlyEvents(int year, int month) async {
    _eventDays.clear();

    for (int day = 1; day <= 31; day++) {
      try {
        final date = DateTime(year, month, day);
        if (date.month != month) break; // stop when next month starts

        final formattedDate =
            "${year}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

        final responses = await Future.wait([
          http.get(Uri.parse(
              "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_agreement_on_date.php?current_dates=$formattedDate")),
          http.get(Uri.parse(
              "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_building.php?current_date_=$formattedDate")),
          http.get(Uri.parse(
              "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_website_visit.php?dates=$formattedDate")),
        ]);

        bool hasEvent = false;

        if (responses[0].statusCode == 200 &&
            responses[0].body.contains("success")) {
          final a = AgreementTaskResponse.fromRawJson(responses[0].body);
          if (a.data.isNotEmpty) hasEvent = true;
        }

        if (responses[1].statusCode == 200 &&
            responses[1].body.contains("success")) {
          final f = FuturePropertyResponse.fromRawJson(responses[1].body);
          if (f.data.isNotEmpty) hasEvent = true;
        }

        if (responses[2].statusCode == 200 &&
            responses[2].body.contains("success")) {
          final w = WebsiteVisitResponse.fromRawJson(responses[2].body);
          if (w.data.isNotEmpty) hasEvent = true;
        }

        if (hasEvent) {
          _eventDays[DateTime(year, month, day)] = true;
        }
      } catch (_) {}
    }

    if (mounted) setState(() {});

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

  Widget _buildPendingAgreementCard(
      AdminPendingAgreement t,
      bool isDark,
      ) {
    final statusColor = Colors.orange;

    return _responsiveCard(
      child: GestureDetector(
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
                  color: Colors.white70,
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

              /// 📍 ADDRESS
              Row(
                children: [
                  Icon(
                    PhosphorIcons.map_pin,
                    size: 14,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t.rentedAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
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
      ),
    );
  }
  String formatReminderDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd-MMM-yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  Widget _buildBuildingCallingCard(BuildingCalling c, bool isDark) {
    return _responsiveCard(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  Administater_Future_Property_details(
                    buildingId: c.subid.toString(),
                  ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(

              colors: [
                Color(0xFF6366F1), // Indigo-500
                Color(0xFF06B6D4), // Cyan-500
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
                      "Building ID: ${c.subid}",
                      style: TextStyle(
                        fontSize: 11,
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
                "Next Call Date: ${formatReminderDate(c.nextCallingDate)}",
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 12,
                  color: Colors.white70 ,
                ),
              ),

              const SizedBox(height: 6),

              /// 🔹 FIELD WORKER
              Text(
                "FW: ${c.fieldWorkerName} • ${c.fieldWorkerNumber}",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white
                ),
              ),


            ],
          ),
        ),
      )
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
          => AdminDemandDetail(demandId: v.id.toString(),),
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
                        fontWeight: FontWeight.w700,
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
                  color: Colors.white70,
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
                    "Visit: ${v.visitingDate}",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "PoppinsBold",
                      color: Colors.white70,
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
                "FW: ${v.assignedFieldWorkerName}",
                style: TextStyle(
                  fontSize: 12,fontFamily: "PoppinsBold",
                  fontWeight: FontWeight.w600,
                  color: Colors.white70 ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Add Flat Card
  Widget _buildAddFlatCard(AdminAddFlat f, bool isDark) {
    final statusColor = _getLiveUnliveColor(f.liveUnlive);

    return _responsiveCard(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Admin_underflat_futureproperty(
                id: f.pId.toString(),
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
                  color:  Colors.white70 ,
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
              if (f.careTakerName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "${f.careTakerName} • ${f.careTakerNumber}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60 ,
                  ),
                ),
              ],

            ],
          ),
        ),
      ),
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
  Widget _buildAcceptedAgreementCard(
      AdminAcceptedAgreement t, bool isDark) {
    final statusColor = Colors.green;

    return _responsiveCard(
      child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AcceptedDetails(agreementId: t.id.toString()),
              ),
            );
          },
          child:Container(
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
                    color: Colors.white70 ,
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

                /// 📍 ADDRESS
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.map_pin,
                      size: 14,
                      color:Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        t.rentedAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color:Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  // Enhanced Agreement Card with better design
  Widget _buildAgreementCard(AgreementTask t, bool isDark) {
    final statusColor = _getStatusColor(t.status);

    double font(BuildContext c, double base) {
      final w = MediaQuery.of(c).size.width;
      if (w < 360) return base - 2;
      if (w > 600) return base + 1;
      return base;
    }

    return _responsiveCard(
      child: GestureDetector(
        onTap: () {
          print(t.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AllDataDetailsPage(agreementId: t.id.toString()),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xFFEF4444),
                  const Color(0xFFDC2626)
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
                    child: Text(
                      t.status,
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

              /// 👤 OWNER → TENANT
              Text(
                "${t.ownerName}  →  ${t.tenantName}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70 ,
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

              /// 📍 ADDRESS
              Row(
                children: [
                  Icon(
                    PhosphorIcons.map_pin,
                    size: 14,
                    color: Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t.rentedAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildAdminUpcomingFlatCard(UpcomingFlat f, bool isDark) {
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
                color: Colors.white70 ,
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
                color:  Colors.white60 ,
              ),
            ),

            if (f.careTakerName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                "${f.careTakerName} • ${f.careTakerNumber}",
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

  // Enhanced Future Property Card
  Widget _buildFuturePropertyCard(FutureProperty f, bool isDark) {
    return _responsiveCard(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Administater_Future_Property_details(
                buildingId: f.id.toString(),
              ),
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
                  const Color(0xFFF59E0B),
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
                      f.propertyNameAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                      color:Colors.white,
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

              /// 📍 LOCATION + TYPE
              Text(
                "${f.place}  •  ${f.residenceType}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:Colors.white70,
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
                    text: "${f.totalFloor}",
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
                    color: Colors.white,
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
                      color:Colors.white
                  ),
                ),
              ],
            ],
          ),
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
    return _responsiveCard(
      child: GestureDetector(
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
                    color: Colors.white ),
              ),
              const SizedBox(height: 4),
              Text(
                w.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "PoppinsBold",
                    color:  Colors.white),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date: ${w.date}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12),
                  ),
                  const Icon(Icons.calendar_month, size: 16, color: Colors.indigo),
                ],
              ),
            ],
          ),
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

  CalendarFormat _calendarFormat = CalendarFormat.week;
  String _calendarView = "Week";
  Key _calendarKey = UniqueKey();

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
      body: RefreshIndicator(
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
                  key: _calendarKey,
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
                            style: const TextStyle(
                              color: Colors.white,
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
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.indigo),
                ),
              ),
            if (_buildingCalls.isNotEmpty)
              _sectionTitle(
                "Building Call Reminders",
                isDark,
                _buildingCalls.length,
              ),

            ..._buildingCalls.map(
                  (e) => _buildBuildingCallingCard(e, isDark),
            ),

            // 🔹 TASK SECTIONS (SAME AS BEFORE)
            if (_agreements.isNotEmpty)
              _sectionTitle("Agreements", isDark, _agreements.length),
            ..._agreements.map(
                  (e) => _buildAgreementCard(e, isDark),
            ),

            if (_pendingAgreements.isNotEmpty)
              _sectionTitle(
                  "Pending Agreements", isDark, _pendingAgreements.length),
            ..._pendingAgreements.map(
                  (e) => _buildPendingAgreementCard(e, isDark),
            ),

            if (_acceptedAgreements.isNotEmpty)
              _sectionTitle(
                  "Accepted Agreements", isDark, _acceptedAgreements.length),
            ..._acceptedAgreements.map(
                  (e) => _buildAcceptedAgreementCard(e, isDark),
            ),
            if (_bookedTenantVisits.isNotEmpty)
              _sectionTitle(
                "Booked Tenant Visits",
                isDark,
                _bookedTenantVisits.length,
              ),
            ..._bookedTenantVisits.map(
                  (e) => _buildBookedTenantVisitCard(e, isDark),
            ),

            if (_futureProperties.isNotEmpty)
              _sectionTitle(
                  "Future Properties", isDark, _futureProperties.length),
            ..._futureProperties.map(
                  (e) => _buildFuturePropertyCard(e, isDark),
            ),
            if (_adminUpcomingFlats.isNotEmpty)
              _sectionTitle(
                "Upcoming Flats",
                isDark,
                _adminUpcomingFlats.length,
              ),
            ..._adminUpcomingFlats.map(
                  (e) => _buildAdminUpcomingFlatCard(e, isDark),
            ),

            if (_adminLiveProperties.isNotEmpty)
              _sectionTitle("Live Properties", isDark, _adminLiveProperties.length),
            ..._adminLiveProperties.map((e) => _buildLivePropertyCard(e, isDark)),



            if (_adminTenantDemands.isNotEmpty)
              _sectionTitle("Tenant Demands", isDark, _adminTenantDemands.length),
            ..._adminTenantDemands.map((e) => _buildTenantDemandCard(e, isDark)),

            if (_addFlats.isNotEmpty)
              _sectionTitle("Add Flats", isDark, _addFlats.length),
            ..._addFlats.map(
                  (e) => _buildAddFlatCard(e, isDark),
            ),
            if (_websiteVisits.isNotEmpty)
              _sectionTitle("Website Visits", isDark, _websiteVisits.length),
            ..._websiteVisits.map(
                  (e) => _buildWebsiteVisitCard(e, isDark),
            ),

            if (!_isLoading &&
                _agreements.isEmpty &&
                _futureProperties.isEmpty &&
                _acceptedAgreements.isEmpty &&
                _pendingAgreements.isEmpty &&
                _bookedTenantVisits.isEmpty &&
                _futureProperties.isEmpty &&
                _adminUpcomingFlats.isEmpty &&
                _buildingCalls.isEmpty &&
                _adminLiveProperties.isEmpty &&
                _adminTenantDemands.isEmpty &&
                _addFlats.isEmpty &&
                _websiteVisits.isEmpty)
              _emptyState(isDark),


            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTenantDemandCard(TenantDemand t, bool isDark) {
    return  InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AdminDemandDetail(demandId: t.id.toString()),
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

  Widget _buildLivePropertyCard(LiveFlat f, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                Administater_View_Details(
                  idd: f.propertyId.toString(),
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
            /// 🏢 FACILITY (OPTIONAL)
            if (f.facility.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                f.facility,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color:Colors.white,
                ),
              ),
            ],

            /// 👤 FieldWorkar (OPTIONAL)
            if (f.fieldWarkarName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "${f.fieldWarkarName}",
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
      ),
    );
  }



}