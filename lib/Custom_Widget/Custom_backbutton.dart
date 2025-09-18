import 'package:flutter/material.dart';

class SquareBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const SquareBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:  Icon(
          Icons.arrow_back_ios_new,
          size: 20, // fixed icon size
          color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white, // color adjusts below
        ),
      ),
    );
  }
}
