import 'package:flutter/material.dart';

class JarvisIconButton extends StatelessWidget {
  final double buttonSize;
  final Color? borderColor;
  final double borderRadius;
  final double? borderWidth;
  final Widget icon;
  final Color? fillColor;
  final VoidCallback onPressed;

  const JarvisIconButton({
    Key? key,
    required this.buttonSize,
    this.borderColor,
    required this.borderRadius,
    this.borderWidth,
    this.fillColor,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: fillColor ?? Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
        ),
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}