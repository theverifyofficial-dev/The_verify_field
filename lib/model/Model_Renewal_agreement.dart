// lib/model/Expire_Agreement.dart

class renewalAgreementResponse {
  final bool status;
  final int totalRecords;
  final List<RenewalAgreementData> data;

  renewalAgreementResponse({
    required this.status,
    required this.totalRecords,
    required this.data,
  });

  factory renewalAgreementResponse.fromJson(Map<String, dynamic> json) {
    return renewalAgreementResponse(
      status: json['status'] ?? false,
      totalRecords: json['total_records'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => RenewalAgreementData.fromJson(e))
          .toList(),
    );
  }
}

class RenewalAgreementData {
  final int id;
  final String ownerName;
  final String ownerRelation;
  final String relationPersonNameOwner;
  final String parmanentAddresssOwner;
  final String ownerMobileNo;
  final String ownerAddharNo;
  final String tenantName;
  final String tenantRelation;
  final String relationPersonNameTenant;
  final String permanentAddressTenant;
  final String tenantMobileNo;
  final String tenantAddharNo;
  final String rentedAddress;
  final String monthlyRent;
  final String security;
  final String meter;
  final AgreementDate? shiftingDate;
  final String maintaince;
  final String ownerAadharFront;
  final String ownerAadharBack;
  final String tenantAadharFront;
  final String tenantAadharBack;
  final String agreementPdf;
  final String installmentSecurityAmount;
  final String customMeterUnit;
  final String customMaintenanceCharge;
  final AgreementDate? currentDates;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String tenantImage;
  final String propertyId;
  final String parking;
  final String notryImg;
  final String policeVerificationPdf;
  final String bhk;
  final String floor;
  final String agreementType;
  final String? companyName;
  final String? gstNo;
  final String? panNo;
  final String? panPhoto;
  final String? furniture;
  final int renewalReminderSent;
  final String? renewalReminderSentOn;
  final String? agreementPrice;
  final String? notaryPrice;
  final String paymentAt;
  final String officeReceived;
  final String? officeReceivedAt;
  final String? isPolice;
  final String payment;
  final String isAgreementHide;
  final String? gstType;
  final String? gstPhoto;
  final String? sqft;
  final String? referenceNumber;
  final String? eStampingCertificateNo;
  final AgreementDate? renewalDate;
  final int daysLeft;

  RenewalAgreementData({
    required this.id,
    required this.ownerName,
    required this.ownerRelation,
    required this.relationPersonNameOwner,
    required this.parmanentAddresssOwner,
    required this.ownerMobileNo,
    required this.ownerAddharNo,
    required this.tenantName,
    required this.tenantRelation,
    required this.relationPersonNameTenant,
    required this.permanentAddressTenant,
    required this.tenantMobileNo,
    required this.tenantAddharNo,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.security,
    required this.meter,
    this.shiftingDate,
    required this.maintaince,
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    required this.agreementPdf,
    required this.installmentSecurityAmount,
    required this.customMeterUnit,
    required this.customMaintenanceCharge,
    this.currentDates,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.tenantImage,
    required this.propertyId,
    required this.parking,
    required this.notryImg,
    required this.policeVerificationPdf,
    required this.bhk,
    required this.floor,
    required this.agreementType,
    this.companyName,
    this.gstNo,
    this.panNo,
    this.panPhoto,
    this.furniture,
    required this.renewalReminderSent,
    this.renewalReminderSentOn,
    this.agreementPrice,
    this.notaryPrice,
    required this.paymentAt,
    required this.officeReceived,
    this.officeReceivedAt,
    this.isPolice,
    required this.payment,
    required this.isAgreementHide,
    this.gstType,
    this.gstPhoto,
    this.sqft,
    this.referenceNumber,
    this.eStampingCertificateNo,
    this.renewalDate,
    required this.daysLeft,
  });

  factory RenewalAgreementData.fromJson(Map<String, dynamic> json) {
    return RenewalAgreementData(
      id:                          json['id'] ?? 0,
      ownerName:                   json['owner_name'] ?? '',
      ownerRelation:               json['owner_relation'] ?? '',
      relationPersonNameOwner:     json['relation_person_name_owner'] ?? '',
      parmanentAddresssOwner:      json['parmanent_addresss_owner'] ?? '',
      ownerMobileNo:               json['owner_mobile_no'] ?? '',
      ownerAddharNo:               json['owner_addhar_no'] ?? '',
      tenantName:                  json['tenant_name'] ?? '',
      tenantRelation:              json['tenant_relation'] ?? '',
      relationPersonNameTenant:    json['relation_person_name_tenant'] ?? '',
      permanentAddressTenant:      json['permanent_address_tenant'] ?? '',
      tenantMobileNo:              json['tenant_mobile_no'] ?? '',
      tenantAddharNo:              json['tenant_addhar_no'] ?? '',
      rentedAddress:               json['rented_address'] ?? '',
      monthlyRent:                 json['monthly_rent']?.toString() ?? '0',
      security:                    json['securitys']?.toString() ?? '0',
      meter:                       json['meter'] ?? '',
      shiftingDate:                json['shifting_date'] != null
          ? AgreementDate.fromJson(json['shifting_date'])
          : null,
      maintaince:                  json['maintaince'] ?? '',
      ownerAadharFront:            json['owner_aadhar_front'] ?? '',
      ownerAadharBack:             json['owner_aadhar_back'] ?? '',
      tenantAadharFront:           json['tenant_aadhar_front'] ?? '',
      tenantAadharBack:            json['tenant_aadhar_back'] ?? '',
      agreementPdf:                json['agreement_pdf'] ?? '',
      installmentSecurityAmount:   json['installment_security_amount']?.toString() ?? '0',
      customMeterUnit:             json['custom_meter_unit']?.toString() ?? '0',
      customMaintenanceCharge:     json['custom_maintenance_charge']?.toString() ?? '0',
      currentDates:                json['current_dates'] != null
          ? AgreementDate.fromJson(json['current_dates'])
          : null,
      fieldWorkerName:             json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber:           json['Fieldwarkarnumber'] ?? '',
      tenantImage:                 json['tenant_image'] ?? '',
      propertyId:                  json['property_id']?.toString() ?? '',
      parking:                     json['parking'] ?? '',
      notryImg:                    json['notry_img'] ?? '',
      policeVerificationPdf:       json['police_verification_pdf'] ?? '',
      bhk:                         json['Bhk'] ?? '',
      floor:                       json['floor'] ?? '',
      agreementType:               json['agreement_type'] ?? '',
      companyName:                 json['company_name'],
      gstNo:                       json['gst_no'],
      panNo:                       json['pan_no'],
      panPhoto:                    json['pan_photo'],
      furniture:                   json['furniture'],
      renewalReminderSent:         json['renewal_reminder_sent'] ?? 0,
      renewalReminderSentOn:       json['renewal_reminder_sent_on'],
      agreementPrice:              json['agreement_price']?.toString(),
      notaryPrice:                 json['notary_price']?.toString(),
      paymentAt:                   json['payment_at']?.toString() ?? '0',
      officeReceived:              json['office_received']?.toString() ?? '0',
      officeReceivedAt:            json['office_received_at'],
      isPolice:                    json['is_Police'],
      payment:                     json['payment']?.toString() ?? '0',
      isAgreementHide:             json['is_agreement_hide']?.toString() ?? '0',
      gstType:                     json['gst_type'],
      gstPhoto:                    json['gst_photo'],
      sqft:                        json['Sqft'],
      referenceNumber:             json['Reference_Number'],
      eStampingCertificateNo:      json['eStamping_Certificate_No'],
      renewalDate:                 json['renewal_date'] != null
          ? AgreementDate.fromJson(json['renewal_date'])
          : null,
      daysLeft:                    json['days_left'] ?? 0,
    );
  }
}

class AgreementDate {
  final DateTime date;
  final int timezoneType;
  final String timezone;

  AgreementDate({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory AgreementDate.fromJson(dynamic json) {
    // ✅ Simple string jaise "2026-07-01"
    if (json is String) {
      return AgreementDate(
        date: DateTime.tryParse(json) ?? DateTime.now(),
        timezoneType: 3,
        timezone: 'UTC',
      );
    }
    // ✅ Object jaise {"date": "2026-07-01", ...}
    return AgreementDate(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      timezoneType: json['timezone_type'] ?? 3,
      timezone: json['timezone'] ?? 'UTC',
    );
  }

  // ✅ YEH ADD KARO - missing tha
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'timezone_type': timezoneType,
    'timezone': timezone,
  };
}