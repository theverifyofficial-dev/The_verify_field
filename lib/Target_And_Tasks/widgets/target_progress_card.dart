import 'package:flutter/material.dart';
import '../models/target_progress.dart';

/// One quota tile. Visually derived from the existing
/// `_buildModernTargetCard` inline builder in `Target_details/Monthly_target.dart`
/// (rounded 18px card, icon chip, big "done/target" number, thin progress
/// bar) but pulled out as a standalone, reusable widget instead of a private
/// per-screen method — the merged screen needs the same card in two places
/// (Monthly and Yearly), and the original had no shared version to reuse.
class TargetProgressCard extends StatelessWidget {
  final TargetProgress data;
  final VoidCallback onTap;

  const TargetProgressCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(data.icon, size: 18, color: data.color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${data.done}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${data.target}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: data.percent,
                minHeight: 6,
                backgroundColor: data.color.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation(data.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
