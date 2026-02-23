import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Gradient? gradient;
  final Color? borderColor;
  final double radius;
  final bool glow;
  final Color? glowColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.gradient,
    this.borderColor,
    this.radius = 18,
    this.glow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ?? AppDecorations.cardGradient,
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: (borderColor ?? AppColors.outline).withOpacity(0.7),
        ),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: (glowColor ?? AppColors.accent).withOpacity(0.2),
                  blurRadius: 24,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
