import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class DigitalTwinLogo extends StatefulWidget {
  final double size;
  final bool animated;

  const DigitalTwinLogo({
    super.key,
    this.size = 120,
    this.animated = true,
  });

  @override
  State<DigitalTwinLogo> createState() => _DigitalTwinLogoState();
}

class _DigitalTwinLogoState extends State<DigitalTwinLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      )..repeat();
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: widget.animated
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: DigitalTwinLogoPainter(
                    animated: widget.animated,
                    animationProgress: _controller.value,
                  ),
                );
              },
            )
          : CustomPaint(
              painter: DigitalTwinLogoPainter(animated: false),
            ),
    );
  }
}

class DigitalTwinLogoPainter extends CustomPainter {
  final bool animated;
  final double animationProgress;

  DigitalTwinLogoPainter({
    this.animated = true,
    this.animationProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = size.width / 200; // Original SVG was 200x200

    // Create gradient for physical entity (left)
    final physicalGradient = ui.Gradient.linear(
      Offset(centerX - 40 * scale, centerY - 40 * scale),
      Offset(centerX - 40 * scale + 70 * scale, centerY - 40 * scale + 70 * scale),
      [
        const Color(0xFF667eea),
        const Color(0xFF764ba2),
      ],
    );

    // Create gradient for digital entity (right)
    final digitalGradient = ui.Gradient.linear(
      Offset(centerX + 40 * scale, centerY - 40 * scale),
      Offset(centerX + 40 * scale + 70 * scale, centerY - 40 * scale + 70 * scale),
      [
        const Color(0xFFf093fb),
        const Color(0xFFf5576c),
      ],
    );

    // Physical entity (left) - solid circle
    final physicalPaint = Paint()
      ..shader = physicalGradient
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(centerX - 30 * scale, centerY),
      35 * scale,
      physicalPaint,
    );

    // Physical entity inner circles
    final physicalStroke = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    canvas.drawCircle(
      Offset(centerX - 30 * scale, centerY),
      25 * scale,
      physicalStroke,
    );

    final physicalInner = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(centerX - 30 * scale, centerY),
      15 * scale,
      physicalInner,
    );

    // Digital entity (right) - wireframe circle
    final digitalStroke = Paint()
      ..shader = digitalGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    
    canvas.drawCircle(
      Offset(centerX + 30 * scale, centerY),
      35 * scale,
      digitalStroke,
    );

    // Digital entity dashed inner circle
    final digitalDashed = Paint()
      ..shader = digitalGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    final path = Path();
    path.addArc(
      Rect.fromCircle(
        center: Offset(centerX + 30 * scale, centerY),
        radius: 25 * scale,
      ),
      0,
      2 * 3.14159,
    );
    
    // Draw dashed circle manually
    final dashLength = 4 * scale;
    final dashSpace = 4 * scale;
    for (double angle = 0; angle < 2 * math.pi; angle += (dashLength + dashSpace) / (25 * scale)) {
      final x1 = centerX + 30 * scale + 25 * scale * math.cos(angle);
      final y1 = centerY + 25 * scale * math.sin(angle);
      final x2 = centerX + 30 * scale + 25 * scale * math.cos(angle + dashLength / (25 * scale));
      final y2 = centerY + 25 * scale * math.sin(angle + dashLength / (25 * scale));
      
      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        digitalDashed,
      );
    }

    // Digital entity inner filled circle
    final digitalInner = Paint()
      ..shader = digitalGradient
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFf093fb).withOpacity(0.4);
    
    canvas.drawCircle(
      Offset(centerX + 30 * scale, centerY),
      15 * scale,
      digitalInner,
    );

    // Connection lines between entities
    final connectionPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    
    // Upper connection curve
    final upperPath = Path();
    upperPath.moveTo(centerX - 5 * scale, centerY - 5 * scale);
    upperPath.quadraticBezierTo(
      centerX,
      centerY - 20 * scale,
      centerX + 5 * scale,
      centerY - 5 * scale,
    );
    canvas.drawPath(upperPath, connectionPaint);

    // Lower connection curve
    final lowerPath = Path();
    lowerPath.moveTo(centerX - 5 * scale, centerY + 5 * scale);
    lowerPath.quadraticBezierTo(
      centerX,
      centerY + 20 * scale,
      centerX + 5 * scale,
      centerY + 5 * scale,
    );
    canvas.drawPath(lowerPath, connectionPaint);

    // Data particles (animated)
    if (animated) {
      final particlePaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      // First particle
      final progress1 = animationProgress;
      final particleX1 = centerX - 15 * scale + (30 * scale * progress1);
      final particleY1 = centerY - 5 * scale + (10 * scale * (progress1 - 0.5).abs);
      canvas.drawCircle(
        Offset(particleX1, particleY1),
        2 * scale,
        particlePaint,
      );
      
      // Second particle (offset)
      final progress2 = (animationProgress + 0.3) % 1.0;
      final particleX2 = centerX - 15 * scale + (30 * scale * progress2);
      final particleY2 = centerY + 5 * scale - (10 * scale * (progress2 - 0.5).abs);
      canvas.drawCircle(
        Offset(particleX2, particleY2),
        1.5 * scale,
        particlePaint..color = Colors.white.withOpacity(0.6),
      );
    }

    // Subtle grid pattern overlay
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5 * scale;
    
    // Horizontal lines
    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
    
    // Vertical lines
    for (int i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DigitalTwinLogoPainter oldDelegate) {
    return animated && oldDelegate.animationProgress != animationProgress;
  }
}


