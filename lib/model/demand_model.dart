class TenantDemandModel {
  final int id;
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
    // HANDLE BOTH CASES OF created_date
    String extractCreatedDate(dynamic raw) {
      if (raw is String) {
        return raw; // from list API
      } else if (raw is Map && raw['date'] != null) {
        return raw['date'].toString(); // from detail API
      }
      return "";
    }

    return TenantDemandModel(
      id: int.tryParse(json['id'].toString()) ?? 0,

      tname: json['Tname']?.toString() ?? '',
      tnumber: json['Tnumber']?.toString() ?? '',
      buyRent: json['Buy_rent']?.toString() ?? '',
      reference: json['Reference']?.toString() ?? '',
      price: json['Price']?.toString() ?? '',
      message: json['Message']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      location: json['Location']?.toString() ?? '',
      status: json['Status']?.toString() ?? '',
      result: json['Result']?.toString() ?? '',
      mark: json['mark']?.toString() ?? '0',

      // FIXED: unify both formats
      createdDate: extractCreatedDate(json['created_date']),

      assignedSubadminName: json['assigned_subadmin_name']?.toString(),
      assignedFieldworkerName: json['assigned_fieldworker_name']?.toString(),
    );
  }
}
