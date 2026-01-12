class TenantDemandModel {
  final int id;
  final int r_id;
  final int subid;
  final String tname;
  final String tnumber;
  final String buyRent;
  final String reference;
  final String price;
  final String message;
  final String bhk;
  final String location;
  final String status;
  final String re_status;
  final String result;
  final String mark;
  final String createdDate;
  final String Date;
  final String finishingDate;
  final String? assignedSubadminName;
  final String? assignedFieldworkerName;

  TenantDemandModel({
    required this.id,
    required this.r_id,
    required this.subid,
    required this.tname,
    required this.tnumber,
    required this.buyRent,
    required this.reference,
    required this.price,
    required this.message,
    required this.bhk,
    required this.location,
    required this.status,
    required this.re_status,
    required this.result,
    required this.mark,
    required this.createdDate,
    required this.Date,
    required this.finishingDate ,
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
      r_id: int.tryParse(json['redemand_id'].toString()) ?? 0,
      subid: int.tryParse(json['subid'].toString()) ?? 0,
      tname: json['Tname']?.toString() ?? '',
      tnumber: json['Tnumber']?.toString() ?? '',
      buyRent: json['Buy_rent']?.toString() ?? '',
      reference: json['Reference']?.toString() ?? '',
      price: json['Price']?.toString() ?? '',
      message: json['Message']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      location: json['Location']?.toString() ?? '',
      status: json['Status']?.toString() ?? '',
      re_status: json['redemand_status']?.toString() ?? '',
      result: json['final_reason']?.toString() ?? '',
      mark: json['mark']?.toString() ?? '0',

      // FIXED: unify both formats
      createdDate: extractCreatedDate(json['created_date']) ?? '',
      finishingDate : extractCreatedDate(json['finishing_date']) ?? '',
      Date : extractCreatedDate(json['Date']) ??'',

      assignedSubadminName: json['assigned_subadmin_name']?.toString(),
      assignedFieldworkerName: json['assigned_fieldworker_name']?.toString(),
    );
  }
}

class RedemandTransferModel {
  final int redemandId;
  final int parentDemandId;
  final int demandId;

  final String tname;
  final String tnumber;
  final String buyRent;
  final String price;
  final String bhk;
  final String mark;

  final String redemandStatus;
  final String demandStatus;

  final String assignedSubadminName;
  final String assignedSubadminLocation;
  final String mainAssignedName;
  final String mainAssignedLocation;

  final DateTime? subadminAssignedAt;

  RedemandTransferModel({
    required this.redemandId,
    required this.parentDemandId,
    required this.demandId,
    required this.tname,
    required this.tnumber,
    required this.buyRent,
    required this.price,
    required this.bhk,
    required this.mark,
    required this.redemandStatus,
    required this.demandStatus,
    required this.assignedSubadminName,
    required this.assignedSubadminLocation,
    required this.mainAssignedName,
    required this.mainAssignedLocation,
    required this.subadminAssignedAt,
  });

  factory RedemandTransferModel.fromJson(Map<String, dynamic> json) {
    return RedemandTransferModel(
      redemandId: json["redemand_id"],
      parentDemandId: json["parent_demand_id"],
      demandId: json["demand_id"],

      tname: json["Tname"] ?? "",
      tnumber: json["Tnumber"] ?? "",
      buyRent: json["Buy_rent"] ?? "",
      price: json["Price"] ?? "",
      bhk: json["Bhk"] ?? "",
      mark: json["mark"] ?? "0",

      redemandStatus: json["redemand_status"] ?? "",
      demandStatus: json["demand_status"] ?? "",

      assignedSubadminName: json["assigned_subadmin_name"] ?? "",
      assignedSubadminLocation: json["assigned_subadmin_location"] ?? "",
      mainAssignedName: json["main_assigned_name"] ?? "",
      mainAssignedLocation: json["main_assigned_location"] ?? "",

      subadminAssignedAt: json["subadmin_assigned_at"] != null
          ? DateTime.tryParse(json["subadmin_assigned_at"]["date"])
          : null,
    );
  }
}

