class  StringIdModel {
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
  final String ownerAadharFront;
  final String ownerAadharBack;
  final String tenantAadharFront;
  final String tenantAadharBack;
  final String agreementPdf;
  final String installmentSecurityAmount;
  final String customMeterUnit;
  final String customMaintenanceCharge;
  final String current_date;
  final String Type;  // ✅ new field



  StringIdModel( {
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
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    required this.agreementPdf,
    required this.installmentSecurityAmount,
    required this.customMeterUnit,
    required this.customMaintenanceCharge,
    required this. current_date,
    required this.Type,  // ✅ new field
  });

  factory StringIdModel.fromJson(Map<String, dynamic> json) {
    return StringIdModel(
      current_date: json['current_dates'],
      id: json['id'],
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
      ownerAadharFront: json['owner_aadhar_front'] ?? '',
      ownerAadharBack: json['owner_aadhar_back'] ?? '',
      tenantAadharFront: json['tenant_aadhar_front'] ?? '',
      tenantAadharBack: json['tenant_aadhar_back'] ?? '',
      agreementPdf: json['agreement_pdf'] ?? '',
      installmentSecurityAmount: json['installment_security_amount'] ?? '',
      customMeterUnit: json['custom_meter_unit'] ?? '',
      customMaintenanceCharge: json['custom_maintenance_charge'] ?? '',
      Type: json['agreement_type'] ?? '',
    );
  }
}
