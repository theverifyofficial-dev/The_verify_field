import 'package:flutter/material.dart';

class MovingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const MovingText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<MovingText> createState() => _MovingTextState();
}

class _MovingTextState extends State<MovingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // 🔥 KEY LINE
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(1 - 2 * _controller.value, 0),
              child: child,
            );
          },
          child: Text(widget.text, style: widget.style),
        ),
      ),
    );
  }
}
