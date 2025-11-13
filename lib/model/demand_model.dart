class TenantDemandModel {
  final String id;
  final String tname;
  final String tnumber;
  final String buyRent;
  final String reference;
  final String price;
  final String message;
  final String bhk;
  final String location;
  final String status;
  final String result;
  final String mark;
  final String createdDate;
  final String? assignedSubadminName;
  final String? assignedFieldworkerName;

  TenantDemandModel({
    required this.id,
    required this.tname,
    required this.tnumber,
    required this.buyRent,
    required this.reference,
    required this.price,
    required this.message,
    required this.bhk,
    required this.location,
    required this.status,
    required this.result,
    required this.mark,
    required this.createdDate,
    this.assignedSubadminName,
    this.assignedFieldworkerName,
  });

  factory TenantDemandModel.fromJson(Map<String, dynamic> json) {
    return TenantDemandModel(
      id: json['id'] ?? '',
      tname: json['Tname'] ?? '',
      tnumber: json['Tnumber'] ?? '',
      buyRent: json['Buy_rent'] ?? '',
      reference: json['Reference'] ?? '',
      price: json['Price'] ?? '',
      message: json['Message'] ?? '',
      bhk: json['Bhk'] ?? '',
      location: json['Location'] ?? '',
      status: json['Status'] ?? '',
      result: json['Result'] ?? '',
      mark: json['mark']?.toString() ?? '0',
      createdDate: json['created_date'] ?? '',
      assignedSubadminName: json['assigned_subadmin_name'],
      assignedFieldworkerName: json['assigned_fieldworker_name'],
    );
  }
}