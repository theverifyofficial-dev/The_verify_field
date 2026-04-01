import 'package:intl/intl.dart';

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
  final String adminName;
  final String? assignedSubadminName;
  final String? assignedFieldworkerName;
  final bool isPinned;


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
    required this.finishingDate,
    required this.adminName,
    this.assignedSubadminName,
    this.assignedFieldworkerName,
    required this.isPinned,
  });

  factory TenantDemandModel.fromJson(Map<String, dynamic> json) {
    String extractDate(dynamic raw) {
      if (raw is String) return raw;
      if (raw is Map && raw['date'] != null) {
        return raw['date'].toString();
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
      adminName: json['admin_name']?.toString() ?? '',

      createdDate: extractDate(json['created_date']),
      finishingDate: extractDate(json['finishing_date']),
      Date: extractDate(json['Date']),

      assignedSubadminName: json['assigned_subadmin_name']?.toString(),
      assignedFieldworkerName: json['assigned_fieldworker_name']?.toString(),
      isPinned: json['is_wishlisted']?.toString() == '1',
    );
  }

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;

    try {
      if (raw is String && raw.isNotEmpty) {
        return DateTime.tryParse(raw);
      }

      if (raw is Map && raw['date'] != null) {
        return DateTime.tryParse(raw['date'].toString());
      }
    } catch (_) {}

    return null;
  }

  /// 🔥 unified safe date
  DateTime? get safeCreatedDate {
    final primary = _parseDate(createdDate);
    if (primary != null) return primary;

    return _parseDate(Date);
  }

  /// ✅ UI-ready formatted date
  String get formattedDate {
    final date = safeCreatedDate;
    if (date == null) return "--";

    return DateFormat('d MMM yyyy').format(date);
  }
}