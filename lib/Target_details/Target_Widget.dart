import 'package:flutter/material.dart';

class TargetCard extends StatelessWidget {
  final String title;
  final int done;
  final int total;
  final VoidCallback? onTap;

  const TargetCard(
      this.title,
      this.done,
      this.total, {
        super.key,
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : done / total;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final shadow = isDark ? Colors.black45 : Colors.black12;
    final color = _colorByTitle(title);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: shadow, blurRadius: 10, offset: const Offset(0, 6))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Text(title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(_iconByTitle(title), size: 24, color: color),
            )
          ]),
          const Spacer(),
          RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "$done",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black)),
                TextSpan(
                    text: " / $total",
                    style:
                    TextStyle(color: isDark ? Colors.white54 : Colors.grey)),
              ])),
          const SizedBox(height: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                  minHeight: 10,
                  value: percent,
                  backgroundColor:
                  isDark ? Colors.white10 : Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color))),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("${(percent * 100).toInt()}% Done",
                style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500)),
            Text("${total - done} Left",
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey)),
          ])
        ]),
      ),
    );
  }

  IconData _iconByTitle(String title) {
    if (title.contains("Rent")) return Icons.home_rounded;
    if (title.contains("Buy")) return Icons.currency_rupee_rounded;
    if (title.contains("Commercial")) return Icons.store_rounded;
    if (title.contains("Police")) return Icons.verified_user_rounded;
    if (title.contains("Agreement")) return Icons.description_rounded;
    return Icons.flag_rounded;
  }

  Color _colorByTitle(String title) {
    if (title.contains("Rent")) return const Color(0xFF22C55E);
    if (title.contains("Buy")) return const Color(0xFFA855F7);
    if (title.contains("Commercial")) return const Color(0xFF06B6D4);
    if (title.contains("Police")) return const Color(0xFFF97316);
    if (title.contains("Agreement")) return const Color(0xFFEF4444);
    return Colors.blue;
  }
}

Widget targetGrid(List<Widget> children) {
  return GridView.count(
    padding: const EdgeInsets.all(14),
    crossAxisCount: 2,
    mainAxisSpacing: 14,
    crossAxisSpacing: 14,
    childAspectRatio: 1.05,
    children: children,
  );
}


