import 'package:flutter/material.dart';
import '../models/agent_task.dart';

/// One task row, shared across every urgency group (Due now / Today /
/// Upcoming) and every source feed. Replaces the ~7 differently-styled card
/// widgets `CalenderForFieldWorker.dart` renders per feed with a single
/// component — an agent now learns one card shape instead of one per feed.
class TaskTile extends StatelessWidget {
  final AgentTask task;
  final TaskUrgency urgency;
  final VoidCallback onTap;

  const TaskTile({
    super.key,
    required this.task,
    required this.urgency,
    required this.onTap,
  });

  Color _urgencyColor(BuildContext context) {
    switch (urgency) {
      case TaskUrgency.dueNow:
        return const Color(0xFFE5484D);
      case TaskUrgency.today:
        return const Color(0xFFD68A1F);
      case TaskUrgency.upcoming:
        return Theme.of(context).brightness == Brightness.dark
            ? Colors.white38
            : Colors.black38;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = task.type.color;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF171B22) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(task.type.icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (task.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      task.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.white38 : Colors.black45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4, left: 6),
              decoration: BoxDecoration(
                color: _urgencyColor(context),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
