class AdditionalTenant {
  final String name;
  final String relation;
  final String relation_name;
  final String mobile;
  final String aadhaar;
  final String address;
  final String front;
  final String back;
  final String photo;

  AdditionalTenant({
    required this.name,
    required this.relation,
    required this.relation_name,
    required this.mobile,
    required this.aadhaar,
    required this.address,
    required this.front,
    required this.back,
    required this.photo,
  });

  factory AdditionalTenant.fromJson(Map<String, dynamic> json) {
    return AdditionalTenant(
      name: json['tenant_name'] ?? '',
      relation: json['tenant_relation'] ?? '',
      relation_name: json['relation_person_name_tenant'] ?? '',
      mobile: json['tenant_mobile'] ?? '',
      aadhaar: json['tenant_aadhar_no'] ?? '',
      address: json['tenant_address'] ?? '',
      front: json['tenant_aadhar_front'] ?? '',
      back: json['tenant_aadhar_back'] ?? '',
      photo: json['tenant_photo'] ?? '',
    );
  }
}
