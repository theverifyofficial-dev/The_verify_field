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

  Future<List<TargetProgress>> fetchProgress({
    required String fieldWorkerNumber,
    required String fieldWorkerName,
    required TargetPeriod period,
  }) {
    return period == TargetPeriod.monthly
        ? _fetchMonthly(fieldWorkerNumber, fieldWorkerName)
        : _fetchYearly(fieldWorkerNumber);
  }

  Future<int> _ownerCallsDoneThisMonth() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final key = 'owner_calls_done_${now.year}_${now.month.toString().padLeft(2, '0')}';
    return prefs.getInt(key) ?? 0;
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
        detailBuilder: (_) => MonthlyBookRentScreen(),
      ),
      TargetProgress(
        key: 'live_commercial',
        title: 'Live Commercial',
        done: commercial,
        target: monthlyTargets['Live Commercial']!,
        icon: Icons.store_mall_directory_rounded,
        color: const Color(0xFFF59E0B),
        detailBuilder: (_) => MonthlyCommercialScreen(),
      ),
      TargetProgress(
        key: 'agreement',
        title: 'Agreement',
        done: agreement,
        target: monthlyTargets['Agreement']!,
        icon: Icons.description_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyAgreementExternalScreen(),
      ),
      TargetProgress(
        key: 'police_verification',
        title: 'Police Verification',
        done: police,
        target: monthlyTargets['Police Verification']!,
        icon: Icons.verified_user_rounded,
        color: const Color(0xFFEF4444),
        detailBuilder: (_) => MonthlyPoliceVerificationScreen(),
      ),
      TargetProgress(
        key: 'live_rent',
        title: 'Live Rent',
        done: live.rent,
        target: monthlyTargets['Live Rent']!,
        icon: Icons.home_work_rounded,
        color: const Color(0xFFA855F7),
        detailBuilder: (_) => MonthlyLiveRentScreen(),
      ),
      TargetProgress(
        key: 'live_buy',
        title: 'Live Buy',
        done: live.buy,
        target: monthlyTargets['Live Buy']!,
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyLiveBuyScreen(),
      ),
      TargetProgress(
        key: 'buildings',
        title: 'Buildings',
        done: buildings,
        target: monthlyTargets['Buildings']!,
        icon: Icons.apartment_rounded,
        color: const Color(0xFF06B6D4),
        detailBuilder: (_) => BuildingMonthlyListScreen(),
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
        detailBuilder: (_) => MonthlyBookRentScreen(),
      ),
      TargetProgress(
        key: 'book_buy_y',
        title: 'Book Buy',
        done: book.buy,
        target: yearlyTargets['Book Buy']!,
        icon: Icons.shopping_bag_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyLiveBuyScreen(),
      ),
      TargetProgress(
        key: 'agreement_y',
        title: 'Agreement',
        done: agreement,
        target: yearlyTargets['Agreement']!,
        icon: Icons.description_rounded,
        color: const Color(0xFF36E27B),
        detailBuilder: (_) => MonthlyAgreementExternalScreen(),
      ),
      TargetProgress(
        key: 'police_y',
        title: 'Police Verification',
        done: police,
        target: yearlyTargets['Police Verification']!,
        icon: Icons.verified_user_rounded,
        color: const Color(0xFFEF4444),
        detailBuilder: (_) => MonthlyPoliceVerificationScreen(),
      ),
      TargetProgress(
        key: 'building_y',
        title: 'Building',
        done: buildings,
        target: yearlyTargets['Building']!,
        icon: Icons.apartment_rounded,
        color: const Color(0xFF06B6D4),
        detailBuilder: (_) => BuildingMonthlyListScreen(),
      ),
    ];
  }

  // ---- shape-specific parsers, one per response family actually seen in
  // the legacy screens. Kept separate (rather than one "smart" generic
  // parser) because each endpoint's shape was hand-verified against the
  // live file it was copied from — see the class doc comment above. ----

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
