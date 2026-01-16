class AgreementModel {
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
  final String securitys;
  final String meter;
  final DateTime? shiftingDate;
  final String maintaince;
  final String ownerAadharFront;
  final String ownerAadharBack;
  final String tenantAadharFront;
  final String tenantAadharBack;
  final String agreementPdf;
  final String installmentSecurityAmount;
  final String customMeterUnit;
  final String customMaintenanceCharge;
  final DateTime? currentDate;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String tenantImage;
  final String propertyId;
  final String parking;
  final String notaryImg;
  final String policeVerificationPdf;
  final String bhk;
  final String floor;
  final String withPolice;
  final String payment;
  final String recieved;
  final String? agreementType;

  AgreementModel({
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
    required this.currentDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.tenantImage,
    required this.propertyId,
    required this.parking,
    required this.notaryImg,
    required this.policeVerificationPdf,
    required this.bhk,
    required this.floor,
    required this.withPolice,
    required this.payment,
    required this.recieved,
    required this.agreementType,
  });

  factory AgreementModel.fromJson(Map<String, dynamic> json) {
    return AgreementModel(
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
      securitys: json['securitys'] ?? '',
      meter: json['meter'] ?? '',
      shiftingDate: json['shifting_date'] != null && json['shifting_date']['date'] != null
          ? DateTime.tryParse(json['shifting_date']['date'])
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
      currentDate: json['current_dates'] != null && json['current_dates']['date'] != null
          ? DateTime.tryParse(json['current_dates']['date'])
          : null,
      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',
      tenantImage: json['tenant_image'] ?? '',
      propertyId: json['property_id'] ?? '',
      parking: json['parking'] ?? '',
      notaryImg: json['notry_img'] ?? '',
      policeVerificationPdf: json['police_verification_pdf'] ?? '',
      bhk: json['Bhk'] ?? '',
      withPolice: json['is_Police'] ?? '',
      floor: json['floor'] ?? '',
      payment: json['payment'] ?? '',
      recieved: json['office_received'] ?? '',
      agreementType: json['agreement_type'],
    );
  }
}
