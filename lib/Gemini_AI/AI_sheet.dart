import 'package:flutter/material.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

import 'Demo_chat.dart';


class GeminiChatBottomSheet extends StatelessWidget {
  const GeminiChatBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),

          child: Column(
            children: [
              _SheetHeader(),
              Divider(
                height: 1,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              Expanded(
                child: GeminiChatBody(
                  externalScrollController: scrollController,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}

class _SheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              // Gemini icon with subtle background
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(isDark ? 0.18 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AppImages.AI,
                  height: 20,
                ),
              ),

              const SizedBox(width: 10),

              // Title
              Text(
                "Gemini AI",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                  letterSpacing: 0.3,
                ),
              ),

              const Spacer(),

              // Close button
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: scheme.onSurface.withOpacity(0.7),
                ),
                splashRadius: 20,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

