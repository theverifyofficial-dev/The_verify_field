import 'package:flutter/material.dart';

/// One quota category (e.g. "Agreement", "Buildings") shown as a ring/card
/// in the merged Target & Tasks screen. Replaces the ad-hoc
/// `_buildModernTargetCard(...)` call sites that used to live inline inside
/// `Target_details/Monthly_target.dart` and `Target_details/Yearly_Target.dart`.
class TargetProgress {
  final String key;
  final String title;
  final int done;
  final int target;
  final IconData icon;
  final Color color;

  /// Builder for the screen this card should open when tapped — kept as a
  /// widget builder (not a route object) so callers can pass the exact same
  /// detail screens the old Target_details screens already used, with zero
  /// behavior change.
  final WidgetBuilder detailBuilder;

  const TargetProgress({
    required this.key,
    required this.title,
    required this.done,
    required this.target,
    required this.icon,
    required this.color,
    required this.detailBuilder,
  });

  double get percent => target <= 0 ? 0.0 : (done / target).clamp(0.0, 1.0);

  bool get isOnTrack => percent >= 1.0;

  TargetProgress copyWith({int? done}) => TargetProgress(
        key: key,
        title: title,
        done: done ?? this.done,
        target: target,
        icon: icon,
        color: color,
        detailBuilder: detailBuilder,
      );
}

enum TargetPeriod { monthly, yearly }
