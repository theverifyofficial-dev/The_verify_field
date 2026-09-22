import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/agent_task.dart';

/// Dedicated card for "call the building owner" tasks — deliberately NOT
/// the shared `TaskTile` every other task type uses. Part of the explicit
/// redesign request: owner-calling needs to read as its own thing, not one
/// more row in the general to-do list, and it needs a one-tap way to
/// actually place the call (which no other task type does — everything
/// else just navigates to a detail screen).
///
/// Two separate tap targets, on purpose:
/// - The call button (`onCallTap`) opens the phone dialer via `tel:`.
///   The caller (`target_and_tasks_home.dart`) is what watches for the app
///   coming back to the foreground afterward and opens the outcome sheet —
///   this widget only fires the tap, it has no lifecycle awareness itself.
/// - Tapping the rest of the card (`onLogTap`) opens that same outcome
///   sheet directly, with no call placed first — for a field worker who
///   already called through another channel (their own phone's recent
///   calls, WhatsApp, etc.) and just needs to log what happened.
class OwnerCallCard extends StatelessWidget {
  final AgentTask task;
  final VoidCallback onCallTap;
  final VoidCallback onLogTap;

  const OwnerCallCard({
    super.key,
    required this.task,
    required this.onCallTap,
    required this.onLogTap,
  });

  static const _accent = Color(0xFF2F6FED);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buildingImage = task.raw['_building_image']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF162238), const Color(0xFF122032)]
              : [const Color(0xFFEAF1FF), const Color(0xFFE7F6FB)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accent.withOpacity(0.32)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onLogTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Building photo, when the `due_calls.php` record for
                // this task had one (see `OwnerCallDue.buildingImage`'s
                // doc comment) -- added 2026-09-21 per explicit request.
                // Skipped entirely when empty rather than a placeholder
                // box, since this field's real key is still unconfirmed.
                if (buildingImage.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: buildingImage,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 110,
                        alignment: Alignment.center,
                        color: _accent.withOpacity(0.08),
                        child: const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 110,
                        alignment: Alignment.center,
                        color: _accent.withOpacity(0.08),
                        child: Icon(Icons.broken_image_outlined, color: _accent.withOpacity(0.6), size: 26),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: _accent.withOpacity(0.16), shape: BoxShape.circle),
                  child: const Icon(Icons.apartment_rounded, color: _accent, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (task.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          task.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // The one-tap "actually place the call" button — a filled
                // circular button rather than a plain icon so it reads as
                // its own control, not decoration, next to the card's
                // "open the log sheet" tap zone.
                Material(
                  color: _accent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onCallTap,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.call_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
