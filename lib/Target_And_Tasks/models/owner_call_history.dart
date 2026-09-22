/// A single logged "Building Owner Calls" record from
/// `Building_Calling/call_history.php`.
///
/// `buildingImage` was added later (2026-09-21) per an explicit request to
/// show the building's photo on this record's card. The live response
/// shape for this field was never confirmed (no network egress to
/// `verifyrealestateandservices.in` from this environment, same standing
/// limitation as every other field here) — so, following this file's own
/// existing pattern for uncertain fields (see `status`/`notes` above, and
/// `OwnerCallDue.fromJson`'s multi-key lookup for the same reason), this
/// tries every plausible key spelling for a building/property photo this
/// codebase already uses elsewhere (`Future_Property_details.dart` /
/// `PlotShow.dart` / `Duplicate_Property.dart` all call it something
/// slightly different) rather than assuming one. Empty string means "no
/// image for this call" — callers should just skip rendering it.
class OwnerCallHistory {
  final int id;
  final int propertyId;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final DateTime? callDate;
  final String status;
  final String notes;
  final DateTime? createdAt;
  final String buildingImage;

  const OwnerCallHistory({
    required this.id,
    required this.propertyId,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.callDate,
    required this.status,
    required this.notes,
    required this.createdAt,
    this.buildingImage = '',
  });

  static String _firstNonEmpty(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return '';
  }

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
      buildingImage: _firstNonEmpty(json, [
        'building_image',
        'property_image',
        'image',
        'image_url',
        'photo',
        'photo_url',
        'building_photo',
        'Apartment_Image',
        'apartment_image',
        'img',
      ]),
    );
  }
}
