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
      data: (json['data'] as List<dynamic>)
          .map((e) => AgreementData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'requested_Fieldwarkarnumber': requestedFieldwarkarnumber,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
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
  final String monthlyRent;
  final String securitys;
  final String meter;
  final DateTime shiftingDate;
  final String maintaince;
  final String? ownerAadharFront;
  final String? ownerAadharBack;
  final String? tenantAadharFront;
  final String? tenantAadharBack;
  final String? agreementPdf;
  final String installmentSecurityAmount;
  final String customMeterUnit;
  final String? customMaintenanceCharge;
  final DateTime currentDates;
  final String fieldwarkarname;
  final String fieldwarkarnumber;
  final String? tenantImage;
  final String propertyId;
  final String parking;
  final String? status;    // ✅ new field
  final String? messages;  // ✅ new field


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
    required this.installmentSecurityAmount,
    required this.customMeterUnit,
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

  factory AgreementData.fromJson(Map<String, dynamic> json) {
    return AgreementData(
      id: json['id'] ?? "",
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
      monthlyRent: json['monthly_rent'] ?? "",
      securitys: json['securitys'] ?? "",
      meter: json['meter'] ?? "",
      shiftingDate: DateTime.parse(json['shifting_date']),
      maintaince: json['maintaince'] ?? "",
      ownerAadharFront: json['owner_aadhar_front'],
      ownerAadharBack: json['owner_aadhar_back'],
      tenantAadharFront: json['tenant_aadhar_front'],
      tenantAadharBack: json['tenant_aadhar_back'],
      agreementPdf: json['agreement_pdf'],
      installmentSecurityAmount: json['installment_security_amount'] ?? "",
      customMeterUnit: json['custom_meter_unit'] ?? "",
      customMaintenanceCharge: json['custom_maintenance_charge'],
      currentDates: DateTime.parse(json['current_dates']),
      fieldwarkarname: json['Fieldwarkarname'] ?? "",
      fieldwarkarnumber: json['Fieldwarkarnumber'] ?? "",
      tenantImage: json['tenant_image'],
      propertyId: json['property_id'] ?? "",
      parking: json['parking'] ?? "",
      status: json['status'],       // ✅ map from JSON
      messages: json['messages'],   // ✅ map from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'securitys': securitys,
      'meter': meter,
      'shifting_date': shiftingDate.toIso8601String(),
      'maintaince': maintaince,
      'owner_aadhar_front': ownerAadharFront,
      'owner_aadhar_back': ownerAadharBack,
      'tenant_aadhar_front': tenantAadharFront,
      'tenant_aadhar_back': tenantAadharBack,
      'agreement_pdf': agreementPdf,
      'installment_security_amount': installmentSecurityAmount,
      'custom_meter_unit': customMeterUnit,
      'custom_maintenance_charge': customMaintenanceCharge,
      'current_dates': currentDates.toIso8601String(),
      'Fieldwarkarname': fieldwarkarname,
      'Fieldwarkarnumber': fieldwarkarnumber,
      'tenant_image': tenantImage,
      'property_id': propertyId,
      'parking': parking,
      'status': status,
      'messages': messages,
    };
  }
}
