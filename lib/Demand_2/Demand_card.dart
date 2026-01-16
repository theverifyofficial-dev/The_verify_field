import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DemandColors {
  static const newDemand = Color(0xFF3B82F6);       // Blue
  static const progressing = Color(0xFFF59E0B);    // Amber
  static const disclosed =  Color(0xFFEF4444);     // Green
  static const redemand = Color(0xFF10B981);       // Red
}

Color demandStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "new":
      return DemandColors.newDemand;
    case "progressing":
      return DemandColors.progressing;
    case "disclosed":
      return DemandColors.disclosed;
    case "redemand":
      return DemandColors.redemand;
    default:
      return Colors.grey;
  }
}

Future<List<Map<String, dynamic>>> fetchTodayDemands(String fieldworkerName,) async {
  try {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now()); // ✅ FIXED

    final url =
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/"
        "show_data_base_on_current_date_for_fieldworkar.php"
        "?fieldworker_name=${Uri.encodeQueryComponent(fieldworkerName)}"
        "&date=$today";

    debugPrint("📅 Today: $today");
    debugPrint("👤 Fieldworker: $fieldworkerName");
    debugPrint("🌐 URL: $url");

    final res = await Dio().get(url);

    if (res.statusCode == 200 &&
        res.data is Map &&
        res.data["status"] == true &&
        res.data["data"] is List) {

      return List<Map<String, dynamic>>.from(
        res.data["data"].map((e) => Map<String, dynamic>.from(e)),
      );
    }

    return [];
  } catch (e) {
    debugPrint("❌ fetchTodayDemands error: $e");
    return [];
  }
}



Widget animatedCount({
  required int value,
  required Color color,
  required String label,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.9),
            color.withOpacity(0.65),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => Text(
              "$v",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    ),
  );
}


Widget demandShimmer(bool isDark) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        colors: isDark
            ? [Colors.grey.shade900, Colors.black]
            : [Colors.grey.shade100, Colors.white],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.35 : 0.12),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(height: 20, width: 160, color: Colors.grey.withOpacity(0.3)),
        const SizedBox(height: 14),
        Row(
          children: List.generate(
            2,
                (_) => Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget todayDemandTile(Map<String, dynamic> d) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.black.withOpacity(0.04),
    ),
    child: Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: DemandColors.newDemand,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            d["Tname"] ?? "-",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          d["Location"] ?? "",
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}

Widget customerDemand2CompactCard({
  required bool isDark,
  required bool loading,
  required int newCount,
  required int progressing,
  required int disclosed,
  required int redemand,
  required List<Map<String, dynamic>> todayDemands,
  required VoidCallback onTap,
}) {
  if (loading) return demandShimmer(isDark);

  final total = newCount + progressing + disclosed + redemand;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      // margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.grey.shade900, Colors.black]
              : [Colors.white, Colors.blueGrey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER (Calendar style)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.groups_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Customer Demands 2.0",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$total total",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// COUNTS
          Row(
            children: [
              animatedCount(
                  value: newCount,
                  color: DemandColors.newDemand,
                  label: "New"),
              const SizedBox(width: 8),
              animatedCount(
                  value: progressing,
                  color: DemandColors.progressing,
                  label: "Progress"),
              const SizedBox(width: 8),
              animatedCount(
                  value: redemand,
                  color: DemandColors.redemand,
                  label: "Redemand"),
              const SizedBox(width: 8),

              animatedCount(
                        value: disclosed,
                        color: DemandColors.disclosed,
                        label: "Closed"),


            ],
          ),
          const SizedBox(height: 8),


            const SizedBox(height: 14),
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
                const SizedBox(width: 6),

                const Text(
                  "Today’s New Demands",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Spacer(),

                const Icon(Icons.arrow_forward_ios),
                const SizedBox(width: 6),
              ],
            ),
            const SizedBox(height: 6),
          if (todayDemands.isNotEmpty) ...[
            ...todayDemands.take(3).map(todayDemandTile),
          ],
          if (todayDemands.isEmpty) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No new demands today",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ]

        ],
      ),
    ),
  );
}

