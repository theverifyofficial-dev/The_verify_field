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
  liveProperty,
  bookVisit,
  upcomingFlat,
  addFlat,
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
      case AgentTaskType.liveProperty:
        return Icons.home_work_rounded;
      case AgentTaskType.bookVisit:
        return Icons.event_available_rounded;
      case AgentTaskType.upcomingFlat:
        return Icons.calendar_month_rounded;
      case AgentTaskType.addFlat:
        return Icons.add_home_work_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AgentTaskType.ownerCall:
        return const Color(0xFF2F6FED); // brand blue — matches app accent
      case AgentTaskType.buildingFollowUp:
        return const Color(0xFF17A673); // green
      case AgentTaskType.websiteVisit:
        return const Color(0xFF06B6D4); // cyan, matches Buildings target card
      case AgentTaskType.agreementFollowUp:
        return const Color(0xFF8B5CF6); // purple, matches Live Rent card
      case AgentTaskType.pendingAgreement:
        return const Color(0xFFD68A1F); // amber — awaiting acceptance
      case AgentTaskType.agreementAccept:
        return const Color(0xFF17A673); // green — already accepted
      case AgentTaskType.tenantDemand:
        return const Color(0xFFE5484D); // red
      case AgentTaskType.liveProperty:
        return const Color(0xFFA855F7);
      case AgentTaskType.bookVisit:
        return const Color(0xFFD68A1F); // amber
      case AgentTaskType.upcomingFlat:
        return const Color(0xFF3B82F6);
      case AgentTaskType.addFlat:
        return const Color(0xFF0EA5E9);
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
}
