/// One "call the building owner" reminder from the NEW
/// `Building_Calling/due_calls.php` feed (the API pair specified for the
/// Agent Dashboard redesign: `GET due_calls.php?fieldworkarnumber=...` +
/// `POST submit_call.php`). This REPLACES the old, read-only
/// `building_calling_reminder.php` reminder card for this screen — see
/// `OwnerCallService`'s doc comment for why, and the README's "Owner
/// calling" section for what "replace" means in practice.
///
/// IMPORTANT — field-name assumption flagged for verification:
/// the redesign spec that introduced this API gave the exact request
/// shape (`fieldworkarnumber` query param in, `property_id` /
/// `fieldworkarname` / `fieldworkarnumber` / `status` / `notes` out to
/// `submit_call.php`) but never gave `due_calls.php`'s exact response JSON
/// — and this pass could not call the live endpoint to check (no network
/// egress to `verifyrealestateandservices.in` from this environment).
/// `fromJson` below is therefore intentionally defensive: it tries every
/// plausible key spelling this codebase already uses elsewhere for the
/// same concepts (building id/address/owner name/owner number all appear
/// under different keys across `FutureProperty`, `LiveFlat`, `CallingReminder`
/// in the deleted calendar screen) rather than assuming one. **The first
/// time this runs against the real endpoint, log the raw response and
/// confirm/narrow this list** — see README.
class OwnerCallDue {
  final String propertyId;
  final String buildingAddress;
  final String ownerName;
  final String ownerNumber;
  final String? reason;
  final Map<String, dynamic> raw;

  const OwnerCallDue({
    required this.propertyId,
    required this.buildingAddress,
    required this.ownerName,
    required this.ownerNumber,
    required this.reason,
    required this.raw,
  });

  static String _firstNonEmpty(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return '';
  }

  factory OwnerCallDue.fromJson(Map<String, dynamic> j) {
    return OwnerCallDue(
      propertyId: _firstNonEmpty(j, ['property_id', 'id', 'building_id', 'P_id']),
      buildingAddress: _firstNonEmpty(j, [
        'property_address_for_fieldworkar',
        'propertyname_address',
        'building_address',
        'address',
        'Apartment_Address',
      ]),
      // 'ownername'/'ownernumber' (no underscore, all lowercase) were
      // added after auditing every "owner phone number" JSON key actually
      // used across this codebase's various building/property endpoints —
      // that spelling is what `show_api_for_details_page.php` uses (the
      // endpoint `Future_Property_details.dart` already calls for the
      // same building record), and `due_calls.php` lives in the same
      // "building" API family, so it's the most likely real spelling here
      // even though it couldn't be confirmed live. Every other spelling
      // already known to exist elsewhere in this codebase is kept too, in
      // priority order, so whichever one the live endpoint actually uses
      // still resolves. If none of these match, `OwnerCallService`'s
      // `fetchOwnerNumberFallback` looks the number up from that same
      // building-details endpoint directly by property id instead.
      ownerName: _firstNonEmpty(j, ['ownername', 'owner_name', 'Owner_Name', 'Ownername']),
      ownerNumber: _firstNonEmpty(j, [
        'ownernumber',
        'owner_number',
        'owner_mobile_no',
        'Owner_Number',
        'owner_no',
      ]),
      reason: j['reason']?.toString(),
      raw: Map<String, dynamic>.from(j),
    );
  }

  /// Used by `OwnerCallService.fetchDueCallsResolved` to fill in a phone
  /// number found via the building-details fallback lookup, without
  /// touching anything else about this record.
  OwnerCallDue copyWith({String? ownerNumber, String? ownerName}) => OwnerCallDue(
        propertyId: propertyId,
        buildingAddress: buildingAddress,
        ownerName: ownerName ?? this.ownerName,
        ownerNumber: ownerNumber ?? this.ownerNumber,
        reason: reason,
        raw: raw,
      );
}
