import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/agent_task.dart';
import 'owner_call_service.dart';

/// Fans out to the same feature endpoints `Calender/CalenderForFieldWorker.dart`
/// already called in its own `_fetchData()` for one selected date, and
/// normalizes every response into one `AgentTask` shape. This is a
/// read-only presentation layer over those endpoints (plus one write path,
/// `submitOwnerCall()` below, added for the new owner-calling flow) — it
/// does not replace that deleted file's original parsing logic, which was
/// read from git history (see this directory's README) to keep every field
/// name here byte-for-byte identical to what already worked.
///
/// **Fixed in this pass** (previously silent data-loss bugs, not by
/// design): three of the original ten feeds — pending agreements, accepted
/// agreements, and booked tenant visits — were never fetched at all, so
/// those task types silently never appeared no matter what the backend
/// returned. They're wired in now. Separately, the *old* owner-call feed
/// (`building_calling_reminder.php`, read-only) is intentionally retired
/// from this list — per explicit user decision, owner-call tasks now come
/// from the new `Building_Calling/due_calls.php` API via
/// [OwnerCallService], because that's the pair that also supports logging
/// the call's outcome (`submit_call.php`), which the old feed never did.
class TaskFeedService {
  static const _base =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Calender';

  final OwnerCallService _ownerCallService = OwnerCallService();

  Future<List<AgentTask>> fetchTasksForDate({
    required String fieldWorkerNumber,
    required String fieldWorkerName,
    required DateTime date,
  }) async {
    final d =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final results = await Future.wait([
      _get(Uri.parse(
          '$_base/task_for_agreement_on_date.php?current_dates=$d&Fieldwarkarnumber=$fieldWorkerNumber')),
      _get(Uri.parse(
          '$_base/task_for_building.php?current_date_=$d&fieldworkarnumber=$fieldWorkerNumber')),
      _get(Uri.parse(
          '$_base/task_for_website_visit.php?dates=$d&field_workar_number=$fieldWorkerNumber')),
      _get(Uri.parse(
          '$_base/pending_agreement_task.php?current_dates=$d&Fieldwarkarnumber=$fieldWorkerNumber')),
      _get(Uri.parse(
          '$_base/accept_agreement_task.php?current_dates=$d&Fieldwarkarnumber=$fieldWorkerNumber')),
      _get(Uri.parse(
          '$_base/tenant_demand_for_field_task.php?fieldworker_assigned_at=$d&assigned_fieldworker_name=${Uri.encodeComponent(fieldWorkerName)}')),
      _get(Uri.parse(
          '$_base/live_property_task_for_fieldworkar.php?field_workar_number=$fieldWorkerNumber&date_for_target=$d')),
      _get(Uri.parse(
          '$_base/book_visit_in_tenant_demand_for_fields.php?visiting_dates=$d&assigned_fieldworker_name=${Uri.encodeComponent(fieldWorkerName)}')),
      _get(Uri.parse(
          '$_base/upcoming_flat_for_fieldworkar.php?dates_for_right_avaiable=$d&field_workar_number=$fieldWorkerNumber')),
      _get(
        Uri.parse(
          '$_base/task_for_add_flat_in_future_property.php'
              '?current_dates=$d'
              '&field_workar_number=$fieldWorkerNumber',
        ),
      ),
    ]);

    final tasks = <AgentTask>[];
    tasks.addAll(_parseAgreements(results[0], date));
    tasks.addAll(_parseBuildings(results[1], date));
    tasks.addAll(_parseWebsiteVisits(results[2], date));
    tasks.addAll(_parsePendingAgreements(results[3], date));
    tasks.addAll(_parseAcceptedAgreements(results[4], date));
    tasks.addAll(_parseTenantDemand(results[5], date));
    tasks.addAll(_parseLiveProperty(results[6], date));
    tasks.addAll(_parseBookedVisits(results[7], date));
    tasks.addAll(_parseUpcomingFlats(results[8], date));
    tasks.addAll(_parseAddFlats(results[9], date));

    // Owner-call tasks: the new `due_calls.php` feed. Unlike the other
    // feeds above, this one isn't per-date (the redesign spec's endpoint
    // only takes `fieldworkarnumber` — a due call is "due", not "due on
    // this specific day"), so it's fetched once per load rather than
    // re-filtered per selected date. Every due call is surfaced regardless
    // of which date is being browsed.
    try {
      final dueCalls =
      await _ownerCallService.fetchDueCallsResolved(
        fieldWorkerNumber: fieldWorkerNumber,
      );

      tasks.addAll(
        dueCalls.map(
              (c) => AgentTask(
            id: 'ownercall_${c.propertyId}',
            type: AgentTaskType.ownerCall,
            title: c.ownerName.isNotEmpty
                ? 'Call owner — ${c.ownerName}'
                : 'Call building owner',
            subtitle: c.buildingAddress.isNotEmpty
                ? c.buildingAddress
                : (c.reason ?? ''),
            dueDate: date,
            raw: {
              ...c.raw,
              '_owner_number': c.ownerNumber,
              '_owner_name': c.ownerName,
              '_building_address': c.buildingAddress,
              '_property_id': c.propertyId,
            },
          ),
        ),
      );

      print(
        '[TASK FEED] Owner calls added: ${dueCalls.length}',
      );
    } catch (e, stack) {
      print('[TASK FEED] Owner call feed failed: $e');
      print(stack);
    }

    return tasks;
  }

  /// Logs the outcome of an owner call. Thin pass-through to
  /// [OwnerCallService.submitCall] kept here so every network call this
  /// screen makes — reads and this one write — goes through one service
  /// class, matching the read-only feeds above.
  Future<bool> submitOwnerCall({
    required String propertyId,
    required String fieldWorkerName,
    required String fieldWorkerNumber,
    required String status,
    required String notes,
  }) {
    return _ownerCallService.submitCall(
      propertyId: propertyId,
      fieldWorkerName: fieldWorkerName,
      fieldWorkerNumber: fieldWorkerNumber,
      status: status,
      notes: notes,
    );
  }

  // ---- parsers, one per feed, field names verified against
  // Calender/CalenderForFieldWorker.dart's own model classes (recovered via
  // git history — see README) ----

  List<AgentTask> _parseAgreements(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      final owner = j['owner_name'] ?? '';
      final tenant = j['tenant_name'] ?? '';
      return AgentTask(
        id: 'agreement_${j['id']}',
        type: AgentTaskType.agreementFollowUp,
        title: 'Agreement — $owner / $tenant',
        subtitle: '${j['rented_address'] ?? ''} · ${j['agreement_type'] ?? ''}',
        dueDate: date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  List<AgentTask> _parseBuildings(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      return AgentTask(
        id: 'building_${j['id']}',
        type: AgentTaskType.buildingFollowUp,
        title: j['propertyname_address'] ?? 'Building follow-up',
        subtitle: '${j['place'] ?? ''} · caretaker ${j['caretakername'] ?? ''}',
        dueDate: date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  List<AgentTask> _parseWebsiteVisits(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      return AgentTask(
        id: 'website_${j['id']}',
        type: AgentTaskType.websiteVisit,
        title: 'Website enquiry — ${j['name'] ?? ''}',
        subtitle: j['message'] ?? j['contact_no'] ?? '',
        dueDate: _tryParseDate(j['dates']) ?? date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  /// `pending_agreement_task.php` — field names confirmed against
  /// `PendingAgreement.fromJson`. This feed was never fetched at all
  /// before this pass; it's the same `AgreementDetailPage` destination
  /// (see `_openTask`) the original `_buildPendingAgreementCard` used —
  /// NOT the same destination as the plain `agreementFollowUp` type above.
  List<AgentTask> _parsePendingAgreements(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      final owner = j['owner_name'] ?? '';
      final tenant = j['tenant_name'] ?? '';
      return AgentTask(
        id: 'pending_agreement_${j['id']}',
        type: AgentTaskType.pendingAgreement,
        title: 'Pending agreement — $owner / $tenant',
        subtitle: '${j['rented_address'] ?? ''} · awaiting acceptance',
        dueDate: date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  /// `accept_agreement_task.php` — field names confirmed against
  /// `AcceptedAgreement.fromJson`. Also never fetched before this pass.
  List<AgentTask> _parseAcceptedAgreements(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      final owner = j['owner_name'] ?? '';
      final tenant = j['tenant_name'] ?? '';
      return AgentTask(
        id: 'accepted_agreement_${j['id']}',
        type: AgentTaskType.agreementAccept,
        title: 'Accepted agreement — $owner / $tenant',
        subtitle: j['rented_address'] ?? '',
        dueDate: date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  List<AgentTask> _parseTenantDemand(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      return AgentTask(
        id: 'demand_${j['id']}',
        type: AgentTaskType.tenantDemand,
        title: 'Approach tenant — ${j['Tname'] ?? ''}',
        subtitle: '${j['Bhk'] ?? ''} · ${j['Buy_rent'] ?? ''} · ${j['Location'] ?? ''}',
        dueDate: _tryParseDate(j['Date']) ?? date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  /// Field names confirmed against `LiveFlat.fromJson` in
  /// `CalenderForFieldWorker.dart`.
  List<AgentTask> _parseLiveProperty(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      return AgentTask(
        id: 'live_${j['P_id']}',
        type: AgentTaskType.liveProperty,
        title: '${j['Apartment_name'] ?? 'Live property'} — ${j['Flat_number'] ?? ''}',
        subtitle: '${j['Buy_Rent'] ?? ''} · ${j['locations'] ?? ''}',
        dueDate: date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  /// `book_visit_in_tenant_demand_for_fields.php` — field names confirmed
  /// against `BookedTenantVisit.fromJson`. Never fetched before this pass;
  /// `AgentTaskType.bookVisit` existed in the model with a real `_openTask`
  /// case already wired to `DemandDetail` (same destination as
  /// `_buildBookedTenantVisitCard` used), but no task of this type was
  /// ever produced, so that case was dead code until now.
  List<AgentTask> _parseBookedVisits(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      return AgentTask(
        id: 'book_visit_${j['id']}',
        type: AgentTaskType.bookVisit,
        title: 'Booked visit — ${j['Tname'] ?? ''}',
        subtitle: '${j['Bhk'] ?? ''} · ${j['Location'] ?? ''}',
        dueDate: _tryParseDate(j['Date']) ?? date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  List<AgentTask> _parseUpcomingFlats(dynamic decoded, DateTime date) {
    final list = _dataList(decoded);
    return list.map((j) {
      return AgentTask(
        id: 'upcoming_${j['P_id']}',
        type: AgentTaskType.upcomingFlat,
        title: 'Flat available — ${j['Flat_number'] ?? ''}',
        subtitle: '${j['locations'] ?? ''} · from ${j['dates_for_right_avaiable'] ?? ''}',
        dueDate: _tryParseDate(j['dates_for_right_avaiable']) ?? date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  List<AgentTask> _parseAddFlats(
      dynamic decoded,
      DateTime date,
      ) {
    final list = _dataList(decoded);

    return list.map((j) {
      return AgentTask(
        id: 'add_flat_${j['P_id']}',
        type: AgentTaskType.addFlat,
        title:
        'Add Flat — ${j['Flat_number'] ?? ''}',
        subtitle:
        '${j['Apartment_name'] ?? ''} · '
            '${j['locations'] ?? ''} · '
            '${j['Bhk'] ?? ''}',
        dueDate:
        _tryParseDate(j['dates_for_right_avaiable']) ?? date,
        raw: Map<String, dynamic>.from(j),
      );
    }).toList();
  }

  // ---- shared helpers ----

  /// Most of these feeds respond `{ "status": "ok"|true|"success", "data":
  /// [...] }` (confirmed for every feed above in
  /// `CalenderForFieldWorker.dart`'s own `*Response.fromJson` factories —
  /// note several of them gate on `decoded['status'] == 'success'`
  /// specifically before trusting `data`, which this helper deliberately
  /// does NOT replicate: it accepts any non-error-shaped `data` list
  /// regardless of the status string, which is more lenient than the
  /// original by design — a feed returning data under a status value this
  /// pass didn't anticipate now surfaces it instead of silently dropping
  /// it, matching the "why is data not showing" bug report this pass was
  /// written to fix). A non-list `data`, or a parse failure, both degrade
  /// to "no tasks from this feed" rather than throwing.
  List<Map<String, dynamic>> _dataList(dynamic decoded) {
    if (decoded == null) {
      print('[TASK FEED] Response is null');
      return const [];
    }

    if (decoded is List) {
      print('[TASK FEED] Response is direct List: ${decoded.length}');
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (decoded is! Map) {
      print('[TASK FEED] Unexpected response type: ${decoded.runtimeType}');
      return const [];
    }

    print('[TASK FEED] Response keys: ${decoded.keys.toList()}');

    // Most APIs
    for (final key in ['data', 'result', 'results', 'tasks']) {
      final value = decoded[key];

      if (value is List) {
        print('[TASK FEED] Found "$key": ${value.length} records');

        return value
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    print('[TASK FEED] No task list found in response: $decoded');

    return const [];
  }

  Future<dynamic> _get(Uri uri) async {
    print('');
    print('========================================');
    print('[TASK FEED] GET');
    print(uri);
    print('========================================');

    try {
      final res = await http
          .get(uri)
          .timeout(const Duration(seconds: 15));

      print('[TASK FEED] Status: ${res.statusCode}');
      print('[TASK FEED] Body: ${res.body}');

      if (res.statusCode != 200) {
        print(
          '[TASK FEED] ERROR HTTP ${res.statusCode} for ${uri.path}',
        );
        return null;
      }

      if (res.body.trim().isEmpty) {
        print('[TASK FEED] ERROR Empty response');
        return null;
      }

      try {
        final decoded = jsonDecode(res.body);

        print(
          '[TASK FEED] JSON decoded successfully: '
              '${decoded.runtimeType}',
        );

        return decoded;
      } catch (e) {
        print('[TASK FEED] JSON DECODE ERROR: $e');
        return null;
      }
    } on TimeoutException catch (e) {
      print('[TASK FEED] TIMEOUT: $uri');
      print(e);
      return null;
    } catch (e, stack) {
      print('[TASK FEED] REQUEST ERROR: $uri');
      print(e);
      print(stack);
      return null;
    }
  }

  DateTime? _tryParseDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }
}
