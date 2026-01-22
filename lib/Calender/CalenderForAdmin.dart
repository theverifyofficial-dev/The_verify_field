// calendar_task_page.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Calender/CalenderForFieldWorker.dart';
import 'package:verify_feild_worker/Rent%20Agreement/history_agreement/Accept_agreement.dart';

import '../Administrator/Admin_future _property/Admin_under_flats.dart';
import '../Administrator/Admin_future _property/Future_Property_Details.dart';
import '../Administrator/Administator_Agreement/Admin_Agreement_details.dart';


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
      shiftingDate: json['shifting_date'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      parking: json['parking'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      status: json['status'] ?? '',
      currentDate: json['current_dates'] ?? '',
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
  final String subId;
  final String propertyPhoto;
  final String location;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String bhk;
  final String showPrice;
  final String floor;
  final String totalFloor;
  final String parking;
  final String liveUnlive;
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  AdminAddFlat({
    required this.pId,
    required this.subId,
    required this.propertyPhoto,
    required this.location,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.bhk,
    required this.showPrice,
    required this.floor,
    required this.totalFloor,
    required this.parking,
    required this.liveUnlive,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
  });

  factory AdminAddFlat.fromJson(Map<String, dynamic> json) {
    return AdminAddFlat(
      pId: (json['P_id'] as num?)?.toInt() ?? 0,
      subId: json['subid']?.toString() ?? '',
      propertyPhoto: json['property_photo'] ?? '',
      location: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      parking: json['parking'] ?? '',
      liveUnlive: json['live_unlive'] ?? 'Unknown',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
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
      shiftingDate: json['shifting_date'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      parking: json['parking'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      status: json['status'] ?? 'pending',
      currentDate: json['current_dates'] ?? '',

      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',
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
  List<String> _pendingAgreementWorkerNames = [];

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

    // fetch after first frame so inherited widgets are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(_focusedDay);
      loadUserName();
      _fetchMonthlyEvents(_selectedYear, _selectedMonth).then((_) {
        if (mounted) setState(() {});
      });

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


  String _monthName(int m) => _months[m - 1];
  List<WebsiteVisit> _websiteVisits = [];
  List<String> _agreementWorkerNames = [];
  List<String> _futurePropertyWorkerNames = [];
  List<String> _websiteVisitWorkerNames = [];
  List<AdminAddFlat> _addFlats = [];
  List<AdminAcceptedAgreement> acceptedAgreements = [];

  Future<void> _fetchData(DateTime date) async {
    setState(() => _isLoading = true);

    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    // ✅ Fieldworkers info
    final fieldworkers = [
      {"name": "Sumit", "number": "9711775300"},
      {"name": "Ravi", "number": "9711275300"},
      {"name": "Faizan", "number": "9971172204"},
    ];

    // Temporary combined lists
    List<Map<String, dynamic>> agreements = [];
    List<Map<String, dynamic>> futureProps = [];
    List<Map<String, dynamic>> websiteVisits = [];
    List<Map<String, dynamic>> adminAddFlat = [];
    List<AdminAcceptedAgreement> acceptedAgreements = [];

    try {
      for (final worker in fieldworkers) {
        final number = worker["number"];
        final name = worker["name"];

        final responses = await Future.wait([
          http.get(Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/Calender/task_agreement_for_admin.php?current_dates=$formattedDate")),
          http.get(Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/Calender/task_building_for_admin.php?current_date_=$formattedDate")),
          http.get(Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/Calender/web_visit_for_admin.php?dates=$formattedDate")),
          http.get(Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/Calender/add_flat_in_future_property_for_admin.php?current_dates=$formattedDate")),
          http.get(Uri.parse(
              "https://verifyserve.social/Second%20PHP%20FILE/Calender/accept_agreement_for_admin.php"
                  "?current_dates=$formattedDate&Fieldwarkarnumber=$number"
          )),
          http.get(Uri.parse(
              "https://verifyserve.social/Second%20PHP%20FILE/Calender/pending_agreement_for_admin.php"
                  "?current_dates=$formattedDate&Fieldwarkarnumber=$number"
          )),
        ]);

        // Agreements
        if (responses[0].statusCode == 200 && responses[0].body.isNotEmpty) {
          final a = AgreementTaskResponse.fromRawJson(responses[0].body);
          agreements.addAll(
            a.data.map((e) => {"workerName": name, "data": e}),
          );
        }

        // Future Properties
        if (responses[1].statusCode == 200 && responses[1].body.isNotEmpty) {
          final f = FuturePropertyResponse.fromRawJson(responses[1].body);
          futureProps.addAll(
            f.data.map((e) => {"workerName": name, "data": e}),
          );
        }

        // Website Visits
        if (responses[2].statusCode == 200 && responses[2].body.isNotEmpty) {
          final w = WebsiteVisitResponse.fromRawJson(responses[2].body);
          websiteVisits.addAll(
            w.data.map((e) => {"workerName": name, "data": e}),
          );
        }
        // Admin Add Flat
        if (responses[3].statusCode == 200 && responses[3].body.isNotEmpty) {
          final addFlatRes = AddFlatResponse.fromRawJson(responses[3].body);

          adminAddFlat.addAll(
            addFlatRes.data.map((e) => {
              "data": e,
            }),
          );
        }
        // ✅ Accepted Agreements (Admin)
        if (responses[4].statusCode == 200 && responses[4].body.isNotEmpty) {
          final acc = AdminAcceptedAgreementResponse.fromRawJson(responses[4].body);
          acceptedAgreements.addAll(acc.data);
        }
// ✅ Pending Agreements (Admin)
        if (responses[5].statusCode == 200 && responses[5].body.isNotEmpty) {
          debugPrint("🟠 Pending Agreements Count: ${_pendingAgreements.length}");

          final p =
          AdminPendingAgreementResponse.fromRawJson(responses[5].body);

          _pendingAgreements.addAll(p.data);
        }


      }

      if (!mounted) return;

      setState(() {
        final cleanDate = DateTime(date.year, date.month, date.day);
        final hasEvent =
            agreements.isNotEmpty ||
                acceptedAgreements.isNotEmpty ||
                _pendingAgreements.isNotEmpty ||
                futureProps.isNotEmpty ||
                adminAddFlat.isNotEmpty ||
                websiteVisits.isNotEmpty;

        _eventDays[cleanDate] = hasEvent;

        _agreements = agreements.map((e) => e["data"] as AgreementTask).toList();
        _futureProperties = futureProps.map((e) => e["data"] as FutureProperty).toList();
        _websiteVisits = websiteVisits.map((e) => e["data"] as WebsiteVisit).toList();
        _addFlats = adminAddFlat
            .map((e) => e["data"] as AdminAddFlat)
            .toList();

        _acceptedAgreements = acceptedAgreements;

        // Save worker names (so we can use them in cards)
        _agreementWorkerNames =
            agreements.map((e) => e["workerName"] as String).toList();
        _futurePropertyWorkerNames =
            futureProps.map((e) => e["workerName"] as String).toList();
        _websiteVisitWorkerNames =
            websiteVisits.map((e) => e["workerName"] as String).toList();

        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Exception fetching admin data: $e");
      if (!mounted) return;
      setState(() {
        _agreements = [];
        _acceptedAgreements=[];
        _pendingAgreements=[];
        _futureProperties = [];
        _websiteVisits = [];
        _addFlats=[];
        _isLoading = false;
      });
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
  Widget _buildPendingAgreementCard(
      AdminPendingAgreement t,
      bool isDark,
      ) {
    final statusColor = Colors.orange;

    return GestureDetector(
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.agreementType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Pending",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        t.fieldWorkerName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// BODY
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: PhosphorIcons.user,
                    title: "Owner",
                    value: t.ownerName,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: PhosphorIcons.users,
                    title: "Tenant",
                    value: t.tenantName,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: PhosphorIcons.map_pin,
                    title: "Address",
                    value: t.rentedAddress,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Add Flat Card
  Widget _buildAddFlatCard(AdminAddFlat f, bool isDark) {
    final statusColor = _getLiveUnliveColor(f.liveUnlive);

    return GestureDetector(
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 HEADER (same as Agreement)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Left title
                  Expanded(
                    child: Text(
                      "Add Flat • ${f.flatNumber}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),

                  /// Status + Worker
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          f.liveUnlive,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        f.fieldWorkerName,
                        style:  TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ?Colors.white:Colors.indigo
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// 🔹 CONTENT (info rows like Agreement)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildInfoRow(
                    icon: PhosphorIcons.map_pin,
                    title: "Location",
                    value: f.location,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),

                  _buildInfoRow(
                    icon: PhosphorIcons.house,
                    title: "Address",
                    value: f.apartmentAddress,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.bed,
                          title: "BHK",
                          value: f.bhk,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.buildings,
                          title: "Floor",
                          value: "${f.floor} / ${f.totalFloor}",
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  _buildInfoRow(
                    icon: PhosphorIcons.currency_inr,
                    title: "Price",
                    value: "₹${f.showPrice}",
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.agreementType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Accepted",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      t.fieldWorkerName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  icon: PhosphorIcons.user,
                  title: "Owner",
                  value: t.ownerName,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: PhosphorIcons.users,
                  title: "Tenant",
                  value: t.tenantName,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  icon: PhosphorIcons.map_pin,
                  title: "Address",
                  value: t.rentedAddress,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced Agreement Card with better design
  Widget _buildAgreementCard(AgreementTask t, bool isDark, String workerName) {
    Color statusColor = _getStatusColor(t.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminAgreementDetails(agreementId: t.id.toString()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status and fieldworker
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    t.agreementType,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 6,),
                    Text(
                      t.fieldWorkerName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                          color: isDark ?Colors.white:Colors.indigo
                      ),
                    ),
                  ],)

                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: PhosphorIcons.user,
                    title: "Owner",
                    value: t.ownerName,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: PhosphorIcons.users,
                    title: "Tenant",
                    value: t.tenantName,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: PhosphorIcons.map_pin,
                    title: "Address",
                    value: t.rentedAddress,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Future Property Card
  Widget _buildFuturePropertyCard(FutureProperty f, bool isDark, String workerName) {
    return GestureDetector(
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4)
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    PhosphorIcons.buildings,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f.propertyNameAddress,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      f.buyRent,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 6,),
                  Text(
                    f.fieldWorkerName,
                    style:  TextStyle(
                      color: isDark ?Colors.white:Colors.indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location & Type
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.map_pin,
                          title: "Location",
                          value: f.place,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.house,
                          title: "Type",
                          value: f.residenceType,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Metro & Floors
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.train,
                          title: "Metro",
                          value: "${f.metroName} (${f.metroDistance})",
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.star_fill,
                          title: "Floors",
                          value: f.totalFloor,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Caretaker
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.user,
                          title: "Caretaker",
                          value: f.caretakerName,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoRow(
                          icon: PhosphorIcons.phone,
                          title: "Contact",
                          value: f.caretakerNumber,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Facilities
                  if (f.facility.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Facilities:",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.grey.shade800,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          f.facility,
                          style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                ],
              ),
            ),
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

  Widget _buildWebsiteVisitCard(WebsiteVisit w, bool isDark, String workerName) {
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
                SizedBox(width: 6,),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    w.fieldWorkerName,
                    style:  TextStyle(
                      color: isDark ?Colors.white:Colors.indigo,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
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
                Row(
                  children: [
                    const Icon(Icons.link, size: 16, color: Colors.indigo),
                    const SizedBox(width: 4),
                    Text(
                      "Open",
                      style: TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
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

  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _calendarView = "Month";

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
                value == "Month" ? CalendarFormat.month : CalendarFormat.week;
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
                  // ✅ Agreements Section
                  if (_agreements.isNotEmpty)
                    _sectionTitle("Agreements", isDark, _agreements.length),
                  ...List.generate(
                    _agreements.length,
                        (i) => _buildAgreementCard(
                      _agreements[i],
                      isDark,
                      _agreementWorkerNames[i],
                    ),
                  ),
                  // ✅ Pending Agreements Section
                  if (_pendingAgreements.isNotEmpty)
                    _sectionTitle(
                      "Pending Agreements",
                      isDark,
                      _pendingAgreements.length,
                    ),

                  ...List.generate(
                    _pendingAgreements.length,
                        (i) => _buildPendingAgreementCard(
                      _pendingAgreements[i],
                      isDark,
                    ),
                  ),

                  // ✅ Accept Agreements Section
                  if (_acceptedAgreements.isNotEmpty)
                    _sectionTitle(
                      "Accepted Agreements",
                      isDark,
                      _acceptedAgreements.length,
                    ),

                  ...List.generate(
                    _acceptedAgreements.length,
                        (i) => _buildAcceptedAgreementCard(
                      _acceptedAgreements[i],
                      isDark,
                    ),
                  ),

                  // ✅ Future Property Section
                  if (_futureProperties.isNotEmpty)
                    _sectionTitle(
                        "Future Properties", isDark, _futureProperties.length),
                  ...List.generate(
                    _futureProperties.length,
                        (i) => _buildFuturePropertyCard(
                      _futureProperties[i],
                      isDark,
                      _futurePropertyWorkerNames[i],
                    ),
                  ),

                  // ✅ Add Flats Section
                  if (_addFlats.isNotEmpty)
                    _sectionTitle("Add Flats", isDark, _addFlats.length),

                  ...List.generate(
                    _addFlats.length,
                        (i) => _buildAddFlatCard(
                      _addFlats[i],
                      isDark,
                    ),
                  ),


                  // ✅ Website Visit Section
                  if (_websiteVisits.isNotEmpty)
                    _sectionTitle("Website Visit Requests", isDark,
                        _websiteVisits.length),
                  ...List.generate(
                    _websiteVisits.length,
                        (i) => _buildWebsiteVisitCard(
                      _websiteVisits[i],
                      isDark,
                      _websiteVisitWorkerNames[i],
                    ),
                  ),

                  // ✅ Empty State
                  if (_agreements.isEmpty &&
                      _futureProperties.isEmpty &&
                      _addFlats.isEmpty &&
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