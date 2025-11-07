class AcceptModel {
  final int id;
  final String ownerName;
  final String ownerRelation;
  final String relationPersonNameOwner;
  final String permanentAddressOwner;
  final String ownerMobileNo;
  final String ownerAadharNo;
  final String tenantName;
  final String tenantRelation;
  final String relationPersonNameTenant;
  final String permanentAddressTenant;
  final String tenantMobileNo;
  final String tenantAadharNo;
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
  final String fieldwarkarName;
  final String fieldwarkarNumber;
  final String tenantImage;
  final String propertyId;
  final String parking;
  final String? bhk;
  final String floor;
  final String agreementType;
  final String? companyName;
  final String? gstNo;
  final String? panNo;
  final String? panPhoto;

  AcceptModel({
    required this.id,
    required this.ownerName,
    required this.ownerRelation,
    required this.relationPersonNameOwner,
    required this.permanentAddressOwner,
    required this.ownerMobileNo,
    required this.ownerAadharNo,
    required this.tenantName,
    required this.tenantRelation,
    required this.relationPersonNameTenant,
    required this.permanentAddressTenant,
    required this.tenantMobileNo,
    required this.tenantAadharNo,
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
    required this.fieldwarkarName,
    required this.fieldwarkarNumber,
    required this.tenantImage,
    required this.propertyId,
    required this.parking,
    this.bhk,
    required this.floor,
    required this.agreementType,
    this.companyName,
    this.gstNo,
    this.panNo,
    this.panPhoto,
  });

  factory AcceptModel.fromJson(Map<String, dynamic> json) {
    return AcceptModel(
      id: json['id'] ?? 0,
      ownerName: json['owner_name'] ?? '',
      ownerRelation: json['owner_relation'] ?? '',
      relationPersonNameOwner: json['relation_person_name_owner'] ?? '',
      permanentAddressOwner: json['parmanent_addresss_owner'] ?? '',
      ownerMobileNo: json['owner_mobile_no'] ?? '',
      ownerAadharNo: json['owner_addhar_no'] ?? '',
      tenantName: json['tenant_name'] ?? '',
      tenantRelation: json['tenant_relation'] ?? '',
      relationPersonNameTenant: json['relation_person_name_tenant'] ?? '',
      permanentAddressTenant: json['permanent_address_tenant'] ?? '',
      tenantMobileNo: json['tenant_mobile_no'] ?? '',
      tenantAadharNo: json['tenant_addhar_no'] ?? '',
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
      fieldwarkarName: json['Fieldwarkarname'] ?? '',
      fieldwarkarNumber: json['Fieldwarkarnumber'] ?? '',
      tenantImage: json['tenant_image'] ?? '',
      propertyId: json['property_id'] ?? '',
      parking: json['parking'] ?? '',
      bhk: json['Bhk'],
      floor: json['floor'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      companyName: json['company_name'],
      gstNo: json['gst_no'],
      panNo: json['pan_no'],
      panPhoto: json['pan_photo'],
    );
  }
}
