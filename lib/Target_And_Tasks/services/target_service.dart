import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/target_progress.dart';
import '../owner_calls_detail.dart';

// Reusing the exact detail screens the old Target_details / Yearly_Target
// screens already opened on tap — this merge changes the shell around them,
// not the destinations, so nothing an agent already relies on moves.
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Book_Rent.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Live_Commercial.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_agreement_external.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_LiveRent.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_LiveBuy.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_under_detail/Monthly_Building.dart';
import 'package:verify_feild_worker/Adminisstrator_Target_details/Monthly_Tab/Monthly_police_verification.dart';

/// Every network call and hardcoded quota in this file was copied verbatim
/// (same endpoint, same JSON field names, same hardcoded target numbers)
/// from `Target_details/Monthly_target.dart` and `Target_details/Yearly_Target.dart`
/// — see project memory `business_logic_targets_roles.md`: these quotas are
/// NOT admin-configurable today, they are Dart constants duplicated per role
/// tree. This service does not fix that; it only stops the merged screen
/// from re-implementing the same fetch/parse logic a third time.
class TargetService {
  static const _base =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Target_New_2026';

  // Same base + endpoints `TaskFeedService` already calls for the
  // date-scoped task list -- added 2026-09-21 per explicit request ("use
  // the same task APIs for showing today's target count of building &
  // agreement") so the Today tab's Buildings/Agreement counts are always
  // in lockstep with what the task list itself shows for today, instead
  // of depending on a second, separately-guessed `_daily.php` endpoint
  // pair whose response shape was never confirmed live.
  static const _taskBase =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Calender';

  static const Map<String, int> monthlyTargets = {
    'Book Rent': 4,
    'Live Commercial': 5,
    'Agreement': 20,
    'Police Verification': 20,
    'Live Rent': 15,
    'Live Buy': 5,
    'Buildings': 25,
    // No real quota exists for this brand-new metric (it has no
    // equivalent in Target_details/Monthly_target.dart, which predates
    // the owner-calling feature) — 20/month is a placeholder pending a
    // real number from whoever owns field-worker quotas. See README.
    'Owner Calls': 20,
  };

  static const Map<String, int> yearlyTargets = {
    'Book Rent': 60,
    'Book Buy': 4,
    'Agreement': 300,
    'Police Verification': 300,
    'Building': 250,
  };

  // Prorated placeholders, NOT real quotas from whoever owns field-worker
  // targets -- added 2026-09-21 because Today/Week tabs need SOME target
  // number and none has ever been given for either period. Computed as
  // ceil(monthlyTargets / 30) for daily and ceil(monthlyTargets / 4) for
  // weekly. Flagged clearly so whoever owns these numbers can correct them
  // -- see README.
  static const Map<String, int> dailyTargets = {
    'Book Rent': 1,
    'Live Commercial': 1,
    // Increased by 2 per explicit request (2026-09-21) -- was the same
    // ceil(monthly/30)=1 placeholder every other metric here still uses.
    'Agreement': 2,
    'Police Verification': 1,
    'Live Rent': 1,
    'Live Buy': 1,
    'Buildings': 1,
    'Owner Calls': 1,
  };


  Future<List<TargetProgress>> fetchProgress({
    required String fieldWorkerNumber,
    required String fieldWorkerName,
    required TargetPeriod period,
  }) {
    switch (period) {
      case TargetPeriod.monthly:
        return _fetchMonthly(fieldWorkerNumber, fieldWorkerName);
      case TargetPeriod.yearly:
        return _fetchYearly(fieldWorkerNumber);
      case TargetPeriod.today:
        return _fetchToday(fieldWorkerNumber, fieldWorkerName);
    }
  }

  /// Owner Calls has no server-side per-period count (the redesign spec's
  /// API pair -- `due_calls.php` + `submit_call.php` -- has no endpoint for
  /// it), so it stays a local, per-device `SharedPreferences` counter, same
  /// as it always has been. (2026-09-21: briefly gained day/week-scoped
  /// sibling keys for the Today/Week tabs; both tabs later dropped Owner
  /// Calls entirely per explicit follow-up, so this is back to just the
  /// one monthly key.) Kept as a `static` public generator, rather than
  /// inlined where it's used, so `target_and_tasks_home.dart`'s
  /// `_recordOwnerCallDone` and `owner_calls_detail.dart`'s equivalent
  /// increment both read the exact same key format instead of two
  /// hand-rolled copies that could silently drift apart.
  static String monthlyOwnerCallsKey([DateTime? now]) {
    final n = now ?? DateTime.now();
    return 'owner_calls_done_${n.year}_${n.month.toString().padLeft(2, '0')}';
  }



  Future<int> _ownerCallsDoneThisMonth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(monthlyOwnerCallsKey()) ?? 0;
  }



  Future<List<TargetProgress>> _fetchMonthly(String fw, String fieldWorkerName) async {
    final buildings = await _statusDataLength(
        Uri.parse('$_base/builidng_monthly_data.php?fieldworkarnumber=$fw'));
    final book = await _bookCounts(
        Uri.parse('$_base/book_monthly_show.php?field_workar_number=$fw'));
    final live = await _rentBuyCounts(
        Uri.parse('$_base/live_monthly_show.php?field_workar_number=$fw'));
    final agreement = await _singleField(
        Uri.parse(
            '$_base/count_api_for_all_agreement_with_reword_monthly.php?Fieldwarkarnumber=$fw'),
        'total_agreement');
    final police = await _singleField(
        Uri.parse('$_base/police_verification_monthly.php?Fieldwarkarnumber=$fw'),
        'total_police_verification');
    final commercial = await _singleField(
        Uri.parse('$_base/commercial_month.php?field_workar_number=$fw'),
        'total_commercial');
    final ownerCallsDone = await _ownerCallsDoneThisMonth();

    return [
      // Building Owner Calls is placed FIRST per explicit user request —
      // it's the one quota tied to a same-screen action (the call sheet),
      // not just a read-only progress ring, so it leads the row instead
      // of trailing after every other card.
      TargetProgress(
        key: 'owner_calls',
        title: 'Owner Calls',
        done: ownerCallsDone,
        target: monthlyTargets['Owner Calls']!,
        icon: Icons.call_rounded,
        color: const Color(0xFF2F6FED),
        detailBuilder: (_) => OwnerCallsDetailScreen(
          fieldWorkerNumber: fw,
          fieldWorkerName: fieldWorkerName,
        ),
      ),
      TargetProgress(
        key: 'book_rent',
        title: 'Book Rent',
        done: book.rent,
        target: monthlyTargets['Book Rent']!,
        icon: Icons.book_rounded,
        color: const Color(0xFF3B82F6),
        detailBuilder: (_) => MonthlyBookRentScreen(number: fw),
      ),
      TargetProgress(
        key: 'live_commercial',
        title: 'Live Commercial',
        done: commercial,
        target: monthlyTargets['Live Commercial']!,
        icon: Icons.store_mall_directory_rounded,
        color: const Color(0xFFF59E0B),
        detailBuilder: (_) => MonthlyCommercialScreen(number: fw),
      ),
      TargetProgress(
        key: 'agreement',
        title: 'Agreement',
        done: agreement,
        target: monthlyTargets['Agreement']!,
        icon: Icons.description_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyAgreementExternalScreen(number: fw),
      ),
      TargetProgress(
        key: 'police_verification',
        title: 'Police Verification',
        done: police,
        target: monthlyTargets['Police Verification']!,
        icon: Icons.verified_user_rounded,
        color: const Color(0xFFEF4444),
        detailBuilder: (_) => MonthlyPoliceVerificationScreen(number: fw),
      ),
      TargetProgress(
        key: 'live_rent',
        title: 'Live Rent',
        done: live.rent,
        target: monthlyTargets['Live Rent']!,
        icon: Icons.home_work_rounded,
        color: const Color(0xFFA855F7),
        detailBuilder: (_) => MonthlyLiveRentScreen(number: fw),
      ),
      TargetProgress(
        key: 'live_buy',
        title: 'Live Buy',
        done: live.buy,
        target: monthlyTargets['Live Buy']!,
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyLiveBuyScreen(number: fw),
      ),
      TargetProgress(
        key: 'buildings',
        title: 'Buildings',
        done: buildings,
        target: monthlyTargets['Buildings']!,
        icon: Icons.apartment_rounded,
        color: const Color(0xFF06B6D4),
        detailBuilder: (_) => BuildingMonthlyListScreen(number: fw),
      ),
    ];
  }

  /// Mirrors `_fetchMonthly` exactly (same six endpoints, same parsers,
  /// same card set/order/colors/detail screens) with each `_monthly`/
  /// `_month` endpoint suffix swapped for `_daily` per explicit
  /// instruction -- these endpoints' response shapes were never confirmed
  /// live (same standing no-network-egress limitation as everywhere else
  /// in this file), so this assumes each one returns the same shape as its
  /// monthly counterpart, just scoped to a different date range server-side.
  /// Per explicit request (2026-09-21), the Today tab shows ONLY 3 cards
  /// -- Buildings, Agreement, Owner Calls -- unlike Monthly/Yearly, which
  /// still show the full set. Only fetches what those 3 cards need (skips
  /// the book/live/police/commercial calls entirely, not just their
  /// cards) since there's no reason to hit endpoints this tab never
  /// displays.
  Future<List<TargetProgress>> _fetchToday(String fw, String fieldWorkerName) async {
    // Reuses `TaskFeedService`'s own `task_for_building.php` /
    // `task_for_agreement_on_date.php` endpoints, scoped to today's date,
    // instead of the separate `building_daily.php` /
    // `count_api_for_all_agreement_with_reword_daily.php` pair this used
    // before (2026-09-21 follow-up request) -- those two endpoints'
    // response shapes were never confirmed live, whereas these are the
    // exact same calls already confirmed working for the task list, so
    // the Today count for each card now always matches the number of
    // building-follow-up / agreement task cards actually shown for today.
    final today = DateTime.now();
    final d = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final buildings = await _taskListLength(Uri.parse(
        '$_taskBase/task_for_building.php?current_date_=$d&fieldworkarnumber=$fw'));
    final agreement = await _taskListLength(Uri.parse(
        '$_taskBase/task_for_agreement_on_date.php?current_dates=$d&Fieldwarkarnumber=$fw'));

    return [
      // Owner Calls REMOVED from the Today tab per explicit follow-up
      // (2026-09-21) -- Today now shows exactly 2 cards: Agreement,
      // Buildings. `fieldWorkerName` is kept as a parameter even though
      // it's now unused here (Owner Calls' `detailBuilder` was the only
      // thing that needed it) -- `fetchProgress`'s signature/dispatch
      // calls every `_fetch*` method the same way, so trimming a card
      // doesn't get to change the method signature.
      TargetProgress(
        key: 'agreement_t',
        title: 'Agreement',
        done: agreement,
        target: dailyTargets['Agreement']!,
        icon: Icons.description_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyAgreementExternalScreen(number: fw),
      ),
      TargetProgress(
        key: 'buildings_t',
        title: 'Buildings',
        done: buildings,
        target: dailyTargets['Buildings']!,
        icon: Icons.apartment_rounded,
        color: const Color(0xFF06B6D4),
        detailBuilder: (_) => BuildingMonthlyListScreen(number: fw),
      ),
    ];
  }

  Future<List<TargetProgress>> _fetchYearly(String fw) async {
    final book = await _bookCounts(
        Uri.parse('$_base/book_yearly_show.php?field_workar_number=$fw'));
    final agreement = await _singleField(
        Uri.parse(
            '$_base/count_api_agreement_yealry_with_reward.php?Fieldwarkarnumber=$fw'),
        'total_agreement');
    final police = await _singleField(
        Uri.parse('$_base/police_verification_yearly.php?Fieldwarkarnumber=$fw'),
        'total_police_verification');
    final buildings = await _statusDataLength(
        Uri.parse('$_base/building_data_yearly.php?fieldworkarnumber=$fw'));

    return [
      TargetProgress(
        key: 'book_rent_y',
        title: 'Book Rent',
        done: book.rent,
        target: yearlyTargets['Book Rent']!,
        icon: Icons.book_rounded,
        color: const Color(0xFF3B82F6),
        detailBuilder: (_) => MonthlyBookRentScreen(number: fw),
      ),
      TargetProgress(
        key: 'book_buy_y',
        title: 'Book Buy',
        done: book.buy,
        target: yearlyTargets['Book Buy']!,
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyLiveBuyScreen(number: fw),
      ),
      TargetProgress(
        key: 'agreement_y',
        title: 'Agreement',
        done: agreement,
        target: yearlyTargets['Agreement']!,
        icon: Icons.description_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyAgreementExternalScreen(number: fw),
      ),
      TargetProgress(
        key: 'police_y',
        title: 'Police Verification',
        done: police,
        target: yearlyTargets['Police Verification']!,
        icon: Icons.verified_user_rounded,
        color: const Color(0xFFEF4444),
        detailBuilder: (_) => MonthlyPoliceVerificationScreen(number: fw),
      ),
      TargetProgress(
        key: 'building_y',
        title: 'Building',
        done: buildings,
        target: yearlyTargets['Building']!,
        icon: Icons.apartment_rounded,
        color: const Color(0xFF06B6D4),
        detailBuilder: (_) => BuildingMonthlyListScreen(number: fw),
      ),
    ];
  }

  // ---- shape-specific parsers, one per response family actually seen in
  // the legacy screens. Kept separate (rather than one "smart" generic
  // parser) because each endpoint's shape was hand-verified against the
  // live file it was copied from — see the class doc comment above. ----

  /// Lenient list-length count, mirroring `TaskFeedService._dataList`'s
  /// own leniency exactly (`data`/`result`/`results`/`tasks`, or a bare
  /// top-level list) -- added 2026-09-21 for `_fetchToday`'s Building/
  /// Agreement counts, which now hit the same endpoints the task list
  /// already calls, so they need the same parser the task list already
  /// uses, not the stricter `{"status": true, "data": [...]}`-only shape
  /// `_statusDataLength` assumes for the (now-unused-by-Today)
  /// `_daily.php` pair.
  Future<int> _taskListLength(Uri uri) async {
    final decoded = await _getJson(uri);
    if (decoded is List) return decoded.length;
    if (decoded is! Map) return 0;
    for (final key in ['data', 'result', 'results', 'tasks']) {
      final value = decoded[key];
      if (value is List) return value.length;
    }
    return 0;
  }

  /// `{ "status": true, "data": [ ... ] }` — count = list length.
  /// Used by the two "builidng_*" endpoints.
  Future<int> _statusDataLength(Uri uri) async {
    final decoded = await _getJson(uri);
    if (decoded is Map && decoded['status'] == true && decoded['data'] is List) {
      return (decoded['data'] as List).length;
    }
    return 0;
  }

  /// `{ "counts": { "<field>": n } }` with a flat `{ "<field>": n }`
  /// fallback — mirrors `_fetchAgreementMonthly` / `_fetchPoliceMonthly` /
  /// `_fetchCommercialMonthly`'s defensive "counts may or may not be nested"
  /// handling exactly.
  Future<int> _singleField(Uri uri, String field) async {
    final decoded = await _getJson(uri);
    if (decoded is! Map) return 0;
    final nested = decoded['counts'];
    if (nested is Map && nested[field] != null) {
      return int.tryParse(nested[field].toString()) ?? 0;
    }
    return int.tryParse(decoded[field]?.toString() ?? '') ?? 0;
  }

  /// `{ "counts": { "rent_count": n, "buy_count": n } }` with a flat
  /// fallback — mirrors `_fetchLiveMonthly`.
  Future<_RentBuy> _rentBuyCounts(Uri uri) async {
    final decoded = await _getJson(uri);
    if (decoded is! Map) return const _RentBuy(0, 0);
    final nested = decoded['counts'];
    final src = (nested is Map) ? nested : decoded;
    return _RentBuy(
      int.tryParse(src['rent_count']?.toString() ?? '') ?? 0,
      int.tryParse(src['buy_count']?.toString() ?? '') ?? 0,
    );
  }

  /// `{ "data": [ { "rent_count": n, "buy_count": n, "period_start": ..., "period_end": ... } ] }`
  /// — mirrors `_fetchBookMonthly` / the yearly equivalent.
  Future<_RentBuy> _bookCounts(Uri uri) async {
    final decoded = await _getJson(uri);
    if (decoded is! Map) return const _RentBuy(0, 0);
    final list = decoded['data'] as List?;
    if (list == null || list.isEmpty) return const _RentBuy(0, 0);
    final row = list[0] as Map;
    return _RentBuy(
      int.tryParse(row['rent_count']?.toString() ?? '') ?? 0,
      int.tryParse(row['buy_count']?.toString() ?? '') ?? 0,
    );
  }


  Future<dynamic> _getJson(Uri uri) async {
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200 || res.body.isEmpty) return null;
      return jsonDecode(res.body);
    } catch (_) {
      return null;
    }
  }
}



class _RentBuy {
  final int rent;
  final int buy;
  const _RentBuy(this.rent, this.buy);
}
