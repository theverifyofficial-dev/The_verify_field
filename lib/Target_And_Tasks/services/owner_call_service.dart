import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/owner_call_due.dart';
import '../models/owner_call_history.dart';

/// The NEW "call the building owner" API pair from the Agent Dashboard
/// redesign spec — this REPLACES `building_calling_reminder.php` as this
/// screen's source of owner-call tasks (per explicit user decision: the old
/// reminder feed is retired here, not kept alongside the new one). Admin's
/// calendar screen is untouched and still uses the old feed — this
/// replacement is scoped to the field-worker Tasks screen only.
///
/// `submitCall()` is the other half: it's what a field worker actually
/// *does* with an owner-call task — log whether the owner answered and any
/// notes — which the old read-only reminder card never supported at all.
class OwnerCallService {
  static const _base =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Building_Calling';

  /// `GET due_calls.php?fieldworkarnumber=...`
  Future<List<OwnerCallDue>> fetchDueCalls({required String fieldWorkerNumber}) async {
    try {
      final uri = Uri.parse('$_base/due_calls.php?fieldworkarnumber=$fieldWorkerNumber');
      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200 || res.body.isEmpty) return const [];
      final decoded = jsonDecode(res.body);
      // Defensive about the envelope shape too, for the same reason
      // `OwnerCallDue`'s doc comment gives for field names: this pass
      // couldn't reach the live endpoint to confirm it's `{data: [...]}`
      // like every other Calendar feed, so a bare top-level list is also
      // accepted rather than silently dropped.
      List<dynamic> list;
      if (decoded is Map && decoded['data'] is List) {
        list = decoded['data'] as List;
      } else if (decoded is List) {
        list = decoded;
      } else {
        return const [];
      }
      return list.whereType<Map>().map((e) => OwnerCallDue.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (_) {
      return const [];
    }
  }

  /// Fallback used when `due_calls.php` itself doesn't include a usable
  /// owner phone number. Confirmed live bug (2026-09-18): the field
  /// worker reported "No phone number on file" every time, which traced
  /// back to `OwnerCallDue.fromJson`'s guessed key list not covering the
  /// real spelling. Rather than keep guessing at `due_calls.php`'s exact
  /// shape (still unconfirmed — no network egress to the backend from
  /// this environment), this reuses the SAME building-details endpoint
  /// `Future_Property_details.dart` already calls successfully for the
  /// same building record — `show_api_for_details_page.php?id=<building
  /// id>` — confirmed by reading that screen's own working code to return
  /// `ownername`/`ownernumber` for a given id. Returns null on any
  /// failure; callers already have a "no number" path for that case.
  Future<String?> fetchOwnerNumberFallback(String propertyId) async {
    if (propertyId.isEmpty) return null;
    try {
      final uri = Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_for_details_page.php?id=$propertyId');
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200 || res.body.isEmpty) return null;
      final decoded = jsonDecode(res.body);
      List list;
      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map && decoded['data'] is List) {
        list = decoded['data'] as List;
      } else if (decoded is Map && decoded['Table'] is List) {
        list = decoded['Table'] as List;
      } else {
        return null;
      }
      if (list.isEmpty) return null;
      final row = list.first;
      if (row is Map) {
        final number = row['ownernumber']?.toString().trim();
        if (number != null && number.isNotEmpty) return number;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// `fetchDueCalls()` plus the fallback lookup above for any call missing
  /// a phone number. Both `TaskFeedService` (the Tasks screen's owner-call
  /// section) and `OwnerCallsDetailScreen` (the Target section's detail
  /// screen) call this instead of `fetchDueCalls()` directly, so the
  /// fallback logic lives in exactly one place rather than being
  /// duplicated at each call site.
  Future<List<OwnerCallDue>> fetchDueCallsResolved({required String fieldWorkerNumber}) async {
    final calls = await fetchDueCalls(fieldWorkerNumber: fieldWorkerNumber);
    final resolved = <OwnerCallDue>[];
    for (final c in calls) {
      if (c.ownerNumber.isNotEmpty) {
        resolved.add(c);
        continue;
      }
      final fallback = await fetchOwnerNumberFallback(c.propertyId);
      resolved.add(fallback != null ? c.copyWith(ownerNumber: fallback) : c);
    }
    return resolved;
  }

  /// `POST submit_call.php` with the exact five fields the redesign spec
  /// specified: `property_id`, `fieldworkarname`, `fieldworkarnumber`,
  /// `status` (`"Answered"` / `"Not Answered"`), `notes`. Returns whether
  /// the backend accepted it — callers should not optimistically mark the
  /// call as logged before this returns `true`.

  Future<bool> submitCall({
    required String propertyId,
    required String fieldWorkerName,
    required String fieldWorkerNumber,
    required String status,
    required String notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/submit_call.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'property_id': propertyId,
          'fieldworkarname': fieldWorkerName,
          'fieldworkarnumber': fieldWorkerNumber,
          'status': status,
          'notes': notes,
        }),
      ).timeout(const Duration(seconds: 12));

      print('--- Submit Call ---');
      print('Request: ${jsonEncode({
        'property_id': propertyId,
        'fieldworkarname': fieldWorkerName,
        'fieldworkarnumber': fieldWorkerNumber,
        'status': status,
        'notes': notes,
      })}');
      print('HTTP Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode != 200 || response.body.isEmpty) {
        return false;
      }

      final data = jsonDecode(response.body);

      return data is Map && data['success'] == true;
    } catch (e) {
      print('Submit Call Error: $e');
      return false;
    }
  }

  Future<List<OwnerCallHistory>> fetchCallHistory({
    String? fieldWorkerNumber,
  }) async {
    const baseUrl =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Building_Calling/call_history.php';

    final uri = fieldWorkerNumber != null &&
        fieldWorkerNumber.trim().isNotEmpty
        ? Uri.parse(
      '$baseUrl?fieldworkarnumber=${Uri.encodeQueryComponent(fieldWorkerNumber)}',
    )
        : Uri.parse(baseUrl);

    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200 || response.body.trim().isEmpty) {
        return [];
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        return [];
      }

      final data = decoded['data'];

      if (data is! List) {
        return [];
      }

      return data
          .whereType<Map>()
          .map(
            (item) => OwnerCallHistory.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();
    } catch (e) {
      print('[OWNER CALL HISTORY] Error: $e');
      return [];
    }
  }

}
