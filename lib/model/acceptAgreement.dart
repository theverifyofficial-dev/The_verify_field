class AgreementModel2 {
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
  final String monthlyRent;
  final String securitys;
  final String meter;
  final String shiftingDate;
  final String maintaince;
  final String? ownerAadharFront;
  final String? ownerAadharBack;
  final String? tenantAadharFront;
  final String? tenantAadharBack;
  final String? agreementPdf;
  final String? installmentSecurityAmount;
  final String? customMeterUnit;
  final String? customMaintenanceCharge;
  final String currentDates;
  final String fieldwarkarname;
  final String fieldwarkarnumber;
  final String? tenantImage;
  final String propertyId;
  final String parking;
  final String? status;    // ✅ new field
  final String? messages;  // ✅ new field

  AgreementModel2({
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
    required this.securitys,
    required this.meter,
    required this.shiftingDate,
    required this.maintaince,
    this.ownerAadharFront,
    this.ownerAadharBack,
    this.tenantAadharFront,
    this.tenantAadharBack,
    this.agreementPdf,
    this.installmentSecurityAmount,
    this.customMeterUnit,
    this.customMaintenanceCharge,
    required this.currentDates,
    required this.fieldwarkarname,
    required this.fieldwarkarnumber,
    this.tenantImage,
    required this.propertyId,
    required this.parking,
    this.status,    // ✅ new field
    this.messages,  // ✅ new field
  });

  factory AgreementModel2.fromJson(Map<String, dynamic> json) {
    return AgreementModel2(
      id: json['id'] ?? '',
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
      securitys: json['securitys'] ?? '',
      meter: json['meter'] ?? '',
      shiftingDate: json['shifting_date'] ?? '',
      maintaince: json['maintaince'] ?? '',
      ownerAadharFront: json['owner_aadhar_front'],
      ownerAadharBack: json['owner_aadhar_back'],
      tenantAadharFront: json['tenant_aadhar_front'],
      tenantAadharBack: json['tenant_aadhar_back'],
      agreementPdf: json['agreement_pdf'],
      installmentSecurityAmount: json['installment_security_amount'],
      customMeterUnit: json['custom_meter_unit'],
      customMaintenanceCharge: json['custom_maintenance_charge'],
      currentDates: json['current_dates'] ?? '',
      fieldwarkarname: json['Fieldwarkarname'] ?? '',
      fieldwarkarnumber: json['Fieldwarkarnumber'] ?? '',
      tenantImage: json['tenant_image'],
      propertyId: json['property_id'] ?? '',
      parking: json['parking'] ?? '',
      status: json['status'],       // ✅ map from JSON
      messages: json['messages'],   // ✅ map from JSON
    );
  }
}
