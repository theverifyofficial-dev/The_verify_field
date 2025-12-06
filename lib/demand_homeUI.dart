import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String dateTime;
  final String duration;
  final String kcal;
  final String bpm;
  final String score;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.dateTime,
    required this.duration,
    required this.kcal,
    required this.bpm,
    required this.score,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? Colors.white70 : Colors.black54;

    /// ICON COLORS
    final mainIconColor =
    isDark ? Colors.white70 : const Color(0xFF4A4A4A);

    final statIconColor =
    isDark ? Colors.white60 : const Color(0xFF6D6D6D);

    final arrowColor =
    isDark ? Colors.white54 : const Color(0xFF8A8A8A);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            gradient: LinearGradient(
              colors: isDark
                  ? [
                Color(0xFF2A2A2A), // Dark grey
                Color(0xFF1C1C1C), // Deep grey
                Color(0xFF000000), // Pure black fade
              ]
                  : [
                Color(0xFFFFFFFF), // White
                Color(0xFFF3F3F3), // Light grey
                Color(0xFFE5E5E5), // Soft silver grey
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),

            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.5)
                    : Colors.black.withOpacity(0.15),
                blurRadius: isDark ? 14 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Center(
            child: Icon(
              icon,
              size: 26,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    dateTime,
                    style: TextStyle(fontSize: 14, color: subColor),
                  ),

                  const SizedBox(height: 14),

                  /// 2x2 stats grid (pair layout)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final halfWidth = (constraints.maxWidth) / 2;

                      return Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          _statItem(Icons.timer, duration, Colors.blue, textColor, halfWidth),
                          _statItem(Icons.local_fire_department, kcal, Colors.deepOrange, textColor, halfWidth),
                          _statItem(Icons.favorite, bpm, Colors.red, textColor, halfWidth),
                          _statItem(Icons.add, score, Colors.green, textColor, halfWidth),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, size: 26, color: arrowColor),
          ],
        ),
      ),
    );
  }

  /// REUSABLE stat box
  Widget _statItem(
      IconData icon, String text, Color iconColor, Color textColor, double width) {
    return SizedBox(
      width: width - 12,
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyActivityCard extends StatelessWidget {
  const WeeklyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF111111) : Colors.white;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                Colors.grey.shade900,
                Colors.black87,
                Colors.grey.shade900,
              ]
                  : [
                Colors.white,
                Colors.white,

              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                blurRadius: 25,
                spreadRadius: 1,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF4EB8), // pink
                          Color(0xFF9B4DFF), // purple
                          Color(0xFF3A7AFE), // blue
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Text(
                      "2 out of 5",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: isDark
                        ? Colors.white12
                        : const Color(0xFFE5EEFF),
                    child: const Icon(Icons.add, color: Color(0xFF3A7AFE)),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.redAccent, Colors.orangeAccent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "You need 3 more activities Today.",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// ITEM 1
              ActivityCard(
                icon: Icons.directions_walk,
                title: "Walking",
                dateTime: "Jun 25, 10:00 AM – 10:30 AM",
                duration: "30 min",
                kcal: "128 kcal",
                bpm: "108 avg bpm",
                score: "+3 score",
                onTap: () {},
              ),

              Divider(color: isDark ? Colors.white12 : Colors.grey.shade300),

              /// ITEM 2
              ActivityCard(
                icon: Icons.self_improvement,
                title: "Yoga",
                dateTime: "Jun 25, 10:00 AM – 10:30 AM",
                duration: "30 min",
                kcal: "128 kcal",
                bpm: "108 avg bpm",
                score: "+3 score",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
