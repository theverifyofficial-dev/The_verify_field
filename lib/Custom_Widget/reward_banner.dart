import 'package:flutter/material.dart';

import '../Rent Agreement/Dashboard_screen.dart';

class _RewardBanner extends StatelessWidget {
  final RewardStatus reward;
  static const int target = 20;

  const _RewardBanner({required this.reward});

  @override
  Widget build(BuildContext context) {
    final progress =
    (reward.totalAgreements / target).clamp(0.0, 1.0);

    final unlocked = reward.isDiscounted;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: unlocked
              ? [Colors.green.shade700, Colors.greenAccent.shade400]
              : [Colors.blueGrey.shade800, Colors.blueGrey.shade500],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎉 TITLE
          Row(
            children: [
              Icon(
                unlocked ? Icons.celebration : Icons.trending_up,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  unlocked
                      ? "🎉 Discount Unlocked!"
                      : "Monthly Target Progress",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 🧠 SUBTEXT
          Text(
            unlocked
                ? "You completed ${reward.totalAgreements} agreements this month.\nSpecial pricing is active!"
                : "${reward.totalAgreements} of $target agreements completed",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          // 📊 PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: AlwaysStoppedAnimation<Color>(
                unlocked ? Colors.white : Colors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
