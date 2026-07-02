class ExpireAgreementResponse {
  final bool status;
  final int totalRecords;
  final List<ExpireAgreementData> data;

  ExpireAgreementResponse({
    required this.status,
    required this.totalRecords,
    required this.data,
  });

  factory ExpireAgreementResponse.fromJson(Map<String, dynamic> json) {
    return ExpireAgreementResponse(
      status: json['status'] ?? false,
      totalRecords: json['total_records'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ExpireAgreementData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'total_records': totalRecords,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class ExpireAgreementData {
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

  ExpireAgreementData({
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

  factory ExpireAgreementData.fromJson(Map<String, dynamic> json) {
    return ExpireAgreementData(
      id: json['id'] ?? 0,
      ownerName: json['owner_name'] ?? '',
      ownerRelation: json['owner_relation'] ?? '',
      relationPersonNameOwner: json['relation_person_name_owner'] ?? '',
      parmanentAddresssOwner: json['parmanent_addresss_owner'] ?? '',
      ownerMobileNo: json['owner_mobile_no'] ?? '',
      ownerAddharNo: json['owner_addhar_no'] ?? '',
      tenantName: json['tenant_name'] ?? '',
      tenantRelation: json['tenant_relation'] ?? '',
      relationPersonNameTenant: json['relation_person_name_tenant'] ?? '',
      permanentAddressTenant: json['permanent_address_tenant'] ?? '',
      tenantMobileNo: json['tenant_mobile_no'] ?? '',
      tenantAddharNo: json['tenant_addhar_no'] ?? '',
      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      security: json['securitys'] ?? '',
      meter: json['meter'] ?? '',
      shiftingDate: json['shifting_date'] != null
          ? AgreementDate.fromJson(json['shifting_date'])
          : null,
      maintaince: json['maintaince'] ?? '',
      ownerAadharFront: json['owner_aadhar_front'] ?? '',
      ownerAadharBack: json['owner_aadhar_back'] ?? '',
      tenantAadharFront: json['tenant_aadhar_front'] ?? '',
      tenantAadharBack: json['tenant_aadhar_back'] ?? '',
      agreementPdf: json['agreement_pdf'] ?? '',
      installmentSecurityAmount: json['installment_security_amount'] ?? '',
      customMeterUnit: json['custom_meter_unit'] ?? '',
      customMaintenanceCharge: json['custom_maintenance_charge'] ?? '',
      currentDates: json['current_dates'] != null
          ? AgreementDate.fromJson(json['current_dates'])
          : null,
      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',
      tenantImage: json['tenant_image'] ?? '',
      propertyId: json['property_id'] ?? '',
      parking: json['parking'] ?? '',
      notryImg: json['notry_img'] ?? '',
      policeVerificationPdf: json['police_verification_pdf'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      companyName: json['company_name'],
      gstNo: json['gst_no'],
      panNo: json['pan_no'],
      panPhoto: json['pan_photo'],
      furniture: json['furniture'],
      renewalReminderSent: json['renewal_reminder_sent'] ?? 0,
      renewalReminderSentOn: json['renewal_reminder_sent_on'],
      agreementPrice: json['agreement_price'],
      notaryPrice: json['notary_price'],
      paymentAt: json['payment_at'] ?? '',
      officeReceived: json['office_received'] ?? '',
      officeReceivedAt: json['office_received_at'],
      isPolice: json['is_Police'],
      payment: json['payment'] ?? '',
      isAgreementHide: json['is_agreement_hide'] ?? '',
      gstType: json['gst_type'],
      gstPhoto: json['gst_photo'],
      sqft: json['Sqft'],
      referenceNumber: json['Reference_Number'],
      eStampingCertificateNo: json['eStamping_Certificate_No'],
      renewalDate: json['renewal_date'] != null
          ? AgreementDate.fromJson(json['renewal_date'])
          : null,
      daysLeft: json['days_left'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner_name': ownerName,
    'owner_relation': ownerRelation,
    'relation_person_name_owner': relationPersonNameOwner,
    'parmanent_addresss_owner': parmanentAddresssOwner,
    'owner_mobile_no': ownerMobileNo,
    'owner_addhar_no': ownerAddharNo,
    'tenant_name': tenantName,
    'tenant_relation': tenantRelation,
    'relation_person_name_tenant': relationPersonNameTenant,
    'permanent_address_tenant': permanentAddressTenant,
    'tenant_mobile_no': tenantMobileNo,
    'tenant_addhar_no': tenantAddharNo,
    'rented_address': rentedAddress,
    'monthly_rent': monthlyRent,
    'securitys': security,
    'meter': meter,
    'shifting_date': shiftingDate?.toJson(),
    'maintaince': maintaince,
    'owner_aadhar_front': ownerAadharFront,
    'owner_aadhar_back': ownerAadharBack,
    'tenant_aadhar_front': tenantAadharFront,
    'tenant_aadhar_back': tenantAadharBack,
    'agreement_pdf': agreementPdf,
    'installment_security_amount': installmentSecurityAmount,
    'custom_meter_unit': customMeterUnit,
    'custom_maintenance_charge': customMaintenanceCharge,
    'current_dates': currentDates?.toJson(),
    'Fieldwarkarname': fieldWorkerName,
    'Fieldwarkarnumber': fieldWorkerNumber,
    'tenant_image': tenantImage,
    'property_id': propertyId,
    'parking': parking,
    'notry_img': notryImg,
    'police_verification_pdf': policeVerificationPdf,
    'Bhk': bhk,
    'floor': floor,
    'agreement_type': agreementType,
    'company_name': companyName,
    'gst_no': gstNo,
    'pan_no': panNo,
    'pan_photo': panPhoto,
    'furniture': furniture,
    'renewal_reminder_sent': renewalReminderSent,
    'renewal_reminder_sent_on': renewalReminderSentOn,
    'agreement_price': agreementPrice,
    'notary_price': notaryPrice,
    'payment_at': paymentAt,
    'office_received': officeReceived,
    'office_received_at': officeReceivedAt,
    'is_Police': isPolice,
    'payment': payment,
    'is_agreement_hide': isAgreementHide,
    'gst_type': gstType,
    'gst_photo': gstPhoto,
    'Sqft': sqft,
    'Reference_Number': referenceNumber,
    'eStamping_Certificate_No': eStampingCertificateNo,
    'renewal_date': renewalDate?.toJson(),
    'days_left': daysLeft,
  };
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