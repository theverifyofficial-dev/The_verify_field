class AdminAllAgreementModel {
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
  final String bhk;
  final String floor;
  final String notaryImg;
  final String policeVerificationPdf;
  final String withPolice;
  final String payment;
  final String recieved;
  final String? agreementType;
  final String agreement_price;


  AdminAllAgreementModel( {
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
    required this.agreement_price,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.securitys,
    required this.meter,
    required this.shiftingDate,
    required this.maintaince,
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.notaryImg,
    required this.policeVerificationPdf,
    required this.tenantAadharBack,
    required this.agreementPdf,
    required this.installmentSecurityAmount,
    required this.customMeterUnit,
    required this.customMaintenanceCharge,
    required this. current_date,
    required this.bhk,
    required this.floor,
    required this.withPolice,
    required this.payment,
    required this.recieved,
    required this.agreementType,
  });
  factory AdminAllAgreementModel.fromJson(Map<String, dynamic> json) {
    return AdminAllAgreementModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

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

      // ✅ FIXED
      shiftingDate: _parseDateString(json['shifting_date']),
      current_date: _parseDateString(json['current_dates']),

      maintaince: json['maintaince'] ?? '',
      ownerAadharFront: json['owner_aadhar_front'] ?? '',
      ownerAadharBack: json['owner_aadhar_back'] ?? '',
      tenantAadharFront: json['tenant_aadhar_front'] ?? '',
      tenantAadharBack: json['tenant_aadhar_back'] ?? '',
      agreementPdf: json['agreement_pdf'] ?? '',
      installmentSecurityAmount: json['installment_security_amount'] ?? '',
      customMeterUnit: json['custom_meter_unit'] ?? '',
      customMaintenanceCharge: json['custom_maintenance_charge'] ?? '',

      notaryImg: json['notry_img'] ?? '',
      policeVerificationPdf: json['police_verification_pdf'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',

      // normalize flags
      withPolice: json['is_Police']?.toString() ?? 'false',
      payment: json['payment']?.toString() ?? '0',
      recieved: json['office_received']?.toString() ?? '0',

      agreementType: json['agreement_type'],
      agreement_price: json['agreement_price'] ?? '0',
    );
  }

}
String _parseDateString(dynamic value) {
  if (value == null) return '';

  // API sends direct string
  if (value is String) return value;

  // Sometimes API sends { date: "yyyy-mm-dd" }
  if (value is Map && value['date'] != null) {
    return value['date'].toString();
  }

  return '';
}
