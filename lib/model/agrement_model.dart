class AgreementResponse {
  final String status;
  final String requestedFieldwarkarnumber;
  final int count;
  final List<AgreementData> data;

  AgreementResponse({
    required this.status,
    required this.requestedFieldwarkarnumber,
    required this.count,
    required this.data,
  });

  factory AgreementResponse.fromJson(Map<String, dynamic> json) {
    return AgreementResponse(
      status: json['status'] ?? "",
      requestedFieldwarkarnumber: json['requested_Fieldwarkarnumber'] ?? "",
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AgreementData.fromJson(e))
          .toList(),
    );
  }
}

class AgreementData {
  final String id;
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

  // nullable fields
  final String? monthlyRent;
  final String? securitys;
  final String? meter;
  final DateTime? shiftingDate;
  final String? maintaince;

  final String? ownerAadharFront;
  final String? ownerAadharBack;
  final String? tenantAadharFront;
  final String? tenantAadharBack;
  final String? agreementPdf;

  final String? installmentSecurityAmount;
  final String? customMeterUnit;
  final String? customMaintenanceCharge;
  final DateTime? currentDates;

  final String fieldwarkarname;
  final String fieldwarkarnumber;
  final String? tenantImage;
  final String? propertyId;
  final String? parking;

  final String? status;
  final String? messages;
  final String Type;

  AgreementData({
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
    this.monthlyRent,
    this.securitys,
    this.meter,
    this.shiftingDate,
    this.maintaince,
    this.ownerAadharFront,
    this.ownerAadharBack,
    this.tenantAadharFront,
    this.tenantAadharBack,
    this.agreementPdf,
    this.installmentSecurityAmount,
    this.customMeterUnit,
    this.customMaintenanceCharge,
    this.currentDates,
    required this.fieldwarkarname,
    required this.fieldwarkarnumber,
    this.tenantImage,
    this.propertyId,
    this.parking,
    this.status,
    this.messages,
    required this.Type,
  });

  factory AgreementData.fromJson(Map<String, dynamic> json) {
    return AgreementData(
      id: json['id']?.toString() ?? "",
      ownerName: json['owner_name'] ?? "",
      ownerRelation: json['owner_relation'] ?? "",
      relationPersonNameOwner: json['relation_person_name_owner'] ?? "",
      parmanentAddresssOwner: json['parmanent_addresss_owner'] ?? "",
      ownerMobileNo: json['owner_mobile_no'] ?? "",
      ownerAddharNo: json['owner_addhar_no'] ?? "",

      tenantName: json['tenant_name'] ?? "",
      tenantRelation: json['tenant_relation'] ?? "",
      relationPersonNameTenant: json['relation_person_name_tenant'] ?? "",
      permanentAddressTenant: json['permanent_address_tenant'] ?? "",
      tenantMobileNo: json['tenant_mobile_no'] ?? "",
      tenantAddharNo: json['tenant_addhar_no'] ?? "",

      rentedAddress: json['rented_address'] ?? "",

      monthlyRent: json['monthly_rent']?.toString(),
      securitys: json['securitys']?.toString(),
      meter: json['meter']?.toString(),

      shiftingDate: json['shifting_date'] != null && json['shifting_date'] != ""
          ? DateTime.tryParse(json['shifting_date'])
          : null,

      maintaince: json['maintaince']?.toString(),

      ownerAadharFront: json['owner_aadhar_front'],
      ownerAadharBack: json['owner_aadhar_back'],
      tenantAadharFront: json['tenant_aadhar_front'],
      tenantAadharBack: json['tenant_aadhar_back'],
      agreementPdf: json['agreement_pdf'],

      installmentSecurityAmount:
      json['installment_security_amount']?.toString(),
      customMeterUnit: json['custom_meter_unit']?.toString(),
      customMaintenanceCharge: json['custom_maintenance_charge']?.toString(),

      currentDates: json['current_dates'] != null && json['current_dates'] != ""
          ? DateTime.tryParse(json['current_dates'])
          : null,

      fieldwarkarname: json['Fieldwarkarname'] ?? "",
      fieldwarkarnumber: json['Fieldwarkarnumber'] ?? "",
      tenantImage: json['tenant_image'],

      propertyId: json['property_id']?.toString(),
      parking: json['parking']?.toString(),

      status: json['status']?.toString(),
      messages: json['messages']?.toString(),

      Type: json['agreement_type'] ?? "",
    );
  }
}
