import 'package:flutter/material.dart';

class SmallButtonWidget extends StatelessWidget {

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColorOverwrite;
  final Color? foregroundColorOverwrite;

  const SmallButtonWidget({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.backgroundColorOverwrite,
    this.foregroundColorOverwrite,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColorOverwrite ?? Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: icon != null
          ? Icon(icon, size: 16, color: Theme.of(context).colorScheme.onTertiary)
          : null,
      label: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: foregroundColorOverwrite ?? Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}