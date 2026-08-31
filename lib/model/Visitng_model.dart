class FieldWorkerVisitModel {
  final int id;
  final int userId;
  final int propertyId;
  final String visitFee;
  final String gst;
  final String gatewayFee;
  final String total;
  final String budget;
  final String preferredLocation;
  final DateTime visitDate;
  final String visitTime;
  final String requirements;
  final String paymentStatus;
  final DateTime createdAt;
  final String visitingStatus;
  final String familyStructure;
  final String familyMember;
  final String religion;
  final String shiftingDate;
  final String vichleNo;
  final String fieldWorkerName;

  FieldWorkerVisitModel({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.visitFee,
    required this.gst,
    required this.gatewayFee,
    required this.total,
    required this.budget,
    required this.preferredLocation,
    required this.visitDate,
    required this.visitTime,
    required this.requirements,
    required this.paymentStatus,
    required this.createdAt,
    required this.visitingStatus,
    required this.familyStructure,
    required this.familyMember,
    required this.religion,
    required this.shiftingDate,
    required this.vichleNo,
    required this.fieldWorkerName,
  });

  static DateTime _parseNestedDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Map && value["date"] != null) {
      return DateTime.tryParse(value["date"].toString()) ?? DateTime.now();
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }

  factory FieldWorkerVisitModel.fromJson(Map<String, dynamic> json) {
    return FieldWorkerVisitModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      visitFee: json["visit_fee"]?.toString() ?? "0",
      gst: json["gst"]?.toString() ?? "0",
      gatewayFee: json["gateway_fee"]?.toString() ?? "0",
      total: json["total"]?.toString() ?? "0",
      budget: json["budget"]?.toString() ?? "",
      preferredLocation: json["preferred_location"]?.toString() ?? "",
      visitDate: _parseNestedDate(json["visit_date"]),
      visitTime: json["visit_time"]?.toString() ?? "",
      requirements: json["requirements"]?.toString() ?? "",
      paymentStatus: json["payment_status"]?.toString() ?? "",
      createdAt: _parseNestedDate(json["created_at"]),
      visitingStatus: json["visiting_status"]?.toString() ?? "",
      familyStructure: json["family_structure"]?.toString() ?? "",
      familyMember: json["family_member"]?.toString() ?? "",
      religion: json["religion"]?.toString() ?? "",
      shiftingDate: json["shifting_date"]?.toString() ?? "",
      vichleNo: json["vichle_no"]?.toString() ?? "",
      fieldWorkerName: json["feild_workar_name"]?.toString() ?? "",
    );
  }
}