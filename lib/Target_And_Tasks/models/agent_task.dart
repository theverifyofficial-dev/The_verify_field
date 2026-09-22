import 'package:flutter/material.dart';

/// Which of the ~10 existing Calendar feeds a task came from. Kept distinct
/// from a generic "type" string so each source's own quirky JSON shape stays
/// isolated to one parsing site in `task_feed_service.dart`, matching how
/// `CalenderForFieldWorker.dart` already models each feed as its own class.
enum AgentTaskType {
  ownerCall,
  buildingFollowUp,
  websiteVisit,
  agreementFollowUp,
  pendingAgreement,
  agreementAccept,
  tenantDemand,
  bookVisit,
  upcomingFlat,
  addFlat,
  // `liveProperty` (the `live_property_task_for_fieldworkar.php` feed,
  // "Live Rent"/"Live Buy" data) was REMOVED from the task list entirely
  // per explicit request (2026-09-21) -- see `task_feed_service.dart`'s
  // doc comment on `fetchTasksForDate` for where the fetch/parse used to
  // live. Removed here too (not just stopped-feeding) since nothing
  // referenced this value once the feed was gone.
}

/// How urgently this task should surface. Computed once per task in
/// `task_feed_service.dart` from its due date compared to "today" — this is
/// the piece that used to be left to the agent to figure out by picking a
/// calendar date; now the app decides it.
enum TaskUrgency { dueNow, today, upcoming }

extension AgentTaskTypeMeta on AgentTaskType {
  IconData get icon {
    switch (this) {
      case AgentTaskType.ownerCall:
        return Icons.call_rounded;
      case AgentTaskType.buildingFollowUp:
        return Icons.apartment_rounded;
      case AgentTaskType.websiteVisit:
        return Icons.language_rounded;
      case AgentTaskType.agreementFollowUp:
        return Icons.description_rounded;
      case AgentTaskType.pendingAgreement:
        return Icons.hourglass_bottom_rounded;
      case AgentTaskType.agreementAccept:
        return Icons.verified_rounded;
      case AgentTaskType.tenantDemand:
        return Icons.groups_rounded;
      case AgentTaskType.bookVisit:
        return Icons.event_available_rounded;
      case AgentTaskType.upcomingFlat:
        return Icons.calendar_month_rounded;
      case AgentTaskType.addFlat:
        return Icons.add_home_work_rounded;
    }
  }

  /// Each type's own accent -- used to tint its task-tile GRADIENT (see
  /// `TaskTile`) so every API source reads as visually distinct at a
  /// glance, per explicit request (2026-09-21). Two pairs used to share a
  /// color (buildingFollowUp/agreementAccept both green, pendingAgreement/
  /// bookVisit both amber, upcomingFlat/addFlat both blue-ish) -- given
  /// unique hues now so "different gradient per API type" actually holds
  /// for all 10, not just most of them.
  Color get color {
    switch (this) {
      case AgentTaskType.ownerCall:
        return const Color(0xFF2F6FED); // blue — brand accent
      case AgentTaskType.buildingFollowUp:
        return const Color(0xFF17A673); // green
      case AgentTaskType.websiteVisit:
        return const Color(0xFF06B6D4); // cyan
      case AgentTaskType.agreementFollowUp:
        return const Color(0xFF8B5CF6); // purple
      case AgentTaskType.pendingAgreement:
        return const Color(0xFFD68A1F); // amber — awaiting acceptance
      case AgentTaskType.agreementAccept:
        return const Color(0xFF0D9488); // teal — already accepted
      case AgentTaskType.tenantDemand:
        return const Color(0xFFE5484D); // red
      case AgentTaskType.bookVisit:
        return const Color(0xFFF97316); // orange
      case AgentTaskType.upcomingFlat:
        return const Color(0xFF6366F1); // indigo
      case AgentTaskType.addFlat:
        return const Color(0xFFEC4899); // pink
    }
  }

  /// Human-readable name of the feed/API this task type comes from, shown
  /// as a small tag on its `TaskTile` card so it's unambiguous which
  /// source produced it -- added 2026-09-21 per explicit request ("more
  /// specific that it's come from this API").
  String get sourceLabel {
    switch (this) {
      case AgentTaskType.ownerCall:
        return 'Owner Calling';
      case AgentTaskType.buildingFollowUp:
        return 'New Building';
      case AgentTaskType.websiteVisit:
        return 'Website Visit';
      case AgentTaskType.agreementFollowUp:
        return 'Agreement Follow-up';
      case AgentTaskType.pendingAgreement:
        return 'Pending Agreement';
      case AgentTaskType.agreementAccept:
        return 'Accepted Agreement';
      case AgentTaskType.tenantDemand:
        return 'Tenant Demand';
      case AgentTaskType.bookVisit:
        return 'Booked Visit';
      case AgentTaskType.upcomingFlat:
        return 'Upcoming Flat';
      case AgentTaskType.addFlat:
        return 'Add Flat';
    }
  }
}

/// A single normalized task, regardless of which backend feed it came from.
/// `raw` keeps the original decoded JSON map so a tap can still navigate into
/// whichever existing detail screen that feed already used — this class is a
/// presentation-layer wrapper, not a replacement for the underlying models.
class AgentTask {
  final String id;
  final AgentTaskType type;
  final String title;
  final String subtitle;
  final DateTime? dueDate;
  final Map<String, dynamic> raw;

  const AgentTask({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.raw,
  });

  TaskUrgency urgencyRelativeTo(DateTime today) {
    if (dueDate == null) return TaskUrgency.today;
    final d = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    final t = DateTime(today.year, today.month, today.day);
    if (d.isBefore(t)) return TaskUrgency.dueNow;
    if (d.isAtSameMomentAs(t)) return TaskUrgency.today;
    return TaskUrgency.upcoming;
  }

  /// Best-effort image for this task, straight off whatever the original
  /// feed returned (`raw`) -- added 2026-09-21 per explicit request to show
  /// an image on the task card "if available in the API". None of the 9
  /// `_parse*` methods in `task_feed_service.dart` currently extract an
  /// image field for their own type, and none of this endpoint's real
  /// image keys were ever confirmed live, so this reads directly off `raw`
  /// with the same defensive multi-key lookup already used for
  /// `OwnerCallDue.buildingImage` / `OwnerCallHistory.buildingImage`,
  /// rather than guessing a new key per task type. Empty string (not null)
  /// when nothing matches, so callers can just check `.isNotEmpty`.
  String get imageUrl => _firstNonEmptyRaw(raw, [
        'building_image',
        '_building_image',
        'property_image',
        'image',
        'images',
        'image_url',
        'photo',
        'photo_url',
        'building_photo',
        'Apartment_Image',
        'apartment_image',
        'img',
      ]);

  static String _firstNonEmptyRaw(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return '';
  }
}
