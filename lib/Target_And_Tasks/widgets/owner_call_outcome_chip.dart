import 'package:flutter/material.dart';

/// One of the two selectable "call outcome" tiles used in both owner-call
/// logging UIs (the Tasks screen's bottom sheet and the Target section's
/// detail-screen dialog) — Answered / Not Answered. Pulled out into its
/// own shared widget (2026-09-18) instead of being duplicated privately
/// in each screen, specifically so the two screens' owner-calling UIs
/// don't drift out of sync the way their `_callOwner`/lifecycle-handling
/// code already had to be maintained twice.
class OwnerCallOutcomeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool enabled;
  final bool isDark;
  final VoidCallback onTap;

  const OwnerCallOutcomeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.enabled,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.14)
              : (isDark ? const Color(0xFF171B22) : const Color(0xFFF7F9FC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : (isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: selected ? color : (isDark ? Colors.white38 : Colors.black38)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? color : (isDark ? Colors.white60 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
