class OwnerCallHistory {
  final int id;
  final int propertyId;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final DateTime? callDate;
  final String status;
  final String notes;
  final DateTime? createdAt;

  const OwnerCallHistory({
    required this.id,
    required this.propertyId,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.callDate,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  factory OwnerCallHistory.fromJson(Map<String, dynamic> json) {
    return OwnerCallHistory(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      propertyId: int.tryParse(json['property_id']?.toString() ?? '') ?? 0,
      fieldWorkerName: json['fieldworkarname']?.toString() ?? '',
      fieldWorkerNumber: json['fieldworkarnumber']?.toString() ?? '',
      callDate: DateTime.tryParse(json['call_date']?.toString() ?? ''),
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}