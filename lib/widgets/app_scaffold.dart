import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A0F1C),
            Color(0xFF0D1426),
            Color(0xFF101A30),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: CustomPaint(
                painter: _GridOverlay(),
              ),
            ),
          ),
          Positioned(
            top: -140,
            right: -100,
            child: _GlowOrb(
              size: 280,
              color: AppColors.accentBlue.withOpacity(0.18),
            ),
          ),
          Positioned(
            bottom: -180,
            left: -120,
            child: _GlowOrb(
              size: 320,
              color: AppColors.accent.withOpacity(0.18),
            ),
          ),
          Positioned(
            top: 120,
            left: -140,
            child: _GlowOrb(
              size: 240,
              color: AppColors.accentRose.withOpacity(0.08),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
            body: body,
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.01),
          ],
        ),
      ),
    );
  }
}

class _GridOverlay extends CustomPainter {
  const _GridOverlay();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..strokeWidth = 1;

    const step = 52.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
