import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/agent_task.dart';


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

  Color _urgencyColor() {
    switch (urgency) {
      case TaskUrgency.dueNow:
        return const Color(0xFFE5484D);
      case TaskUrgency.today:
        return const Color(0xFFD68A1F);
      case TaskUrgency.upcoming:
        return const Color(0xFF6B7280);
    }
  }

  String _urgencyLabel() {
    switch (urgency) {
      case TaskUrgency.dueNow:
        return 'DUE NOW';
      case TaskUrgency.today:
        return 'TODAY';
      case TaskUrgency.upcoming:
        return 'UPCOMING';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = task.type.color;
    final hasImage = task.imageUrl.isNotEmpty;
    final urgencyColor = _urgencyColor();

    return Container(
      decoration: BoxDecoration(
        // Per-type tinted gradient, kept from the previous pass -- still
        // the way each API source reads as visually distinct at a glance.
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [color.withOpacity(0.22), const Color(0xFF171B22)]
              : [color.withOpacity(0.14), Colors.white],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.32)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        // Wrapping the *entire* card (image + content) in one Material +
        // InkWell -- rather than only the text column -- is the direct fix
        // for "tap navigation ... fully, not in specific area of the card":
        // every pixel of this widget, including the image, is now part of
        // the same tap target and shows the same ripple.
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                AspectRatio(
                  aspectRatio: 16 / 7,
                  child: CachedNetworkImage(
                    imageUrl: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${task.imageUrl}",
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: color.withOpacity(0.10),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: color),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: color.withOpacity(0.10),
                      child: Icon(task.type.icon, color: color, size: 28),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(task.type.icon, color: color, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: color.withOpacity(isDark ? 0.22 : 0.14),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              task.type.sourceLabel,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: urgencyColor.withOpacity(isDark ? 0.24 : 0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _urgencyLabel(),
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                              color: urgencyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Main data -- the task's title, now allowed to wrap
                    // onto two lines instead of being clipped to one, so
                    // longer real data (an owner+tenant pair, a full
                    // address) is actually readable instead of ellipsized.
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.25,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (task.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
