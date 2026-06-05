import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kaigin_pet/domain/entities/pet.dart';

class PetBirdWidget extends StatefulWidget {
  const PetBirdWidget({
    required this.mood,
    this.size = 180,
    super.key,
  });

  final PetMood mood;
  final double size;

  @override
  State<PetBirdWidget> createState() => _PetBirdWidgetState();
}

class _PetBirdWidgetState extends State<PetBirdWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bobAnimation;
  late Animation<double> _wingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);

    _bobAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _wingAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bobAnimation.value),
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _BirdPainter(
              mood: widget.mood,
              wingAngle: _wingAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class _BirdPainter extends CustomPainter {
  _BirdPainter({required this.mood, required this.wingAngle});

  final PetMood mood;
  final double wingAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // Body gradient
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        colors: [_bodyColorLight, _bodyColorDark],
        center: const Alignment(-0.3, -0.3),
      ).createShader(Rect.fromCenter(
          center: Offset(cx, cy), width: w * 0.6, height: h * 0.55));

    // Belly
    final bellyPaint = Paint()..color = const Color(0xFFFFF0DC);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Wing paint
    final wingPaint = Paint()
      ..shader = LinearGradient(
        colors: [_wingColorLight, _wingColorDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Draw shadow under bird
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + h * 0.38), width: w * 0.5, height: h * 0.1),
      shadowPaint,
    );

    // Draw left wing
    canvas.save();
    canvas.translate(cx - w * 0.26, cy + h * 0.02);
    canvas.rotate(-math.pi / 8 + wingAngle * 1.5);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset.zero, width: w * 0.28, height: h * 0.18),
      wingPaint,
    );
    canvas.restore();

    // Draw right wing
    canvas.save();
    canvas.translate(cx + w * 0.26, cy + h * 0.02);
    canvas.rotate(math.pi / 8 - wingAngle * 1.5);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset.zero, width: w * 0.28, height: h * 0.18),
      wingPaint,
    );
    canvas.restore();

    // Body
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + h * 0.1),
          width: w * 0.52,
          height: h * 0.52),
      bodyPaint,
    );

    // Belly (lighter oval on front)
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + h * 0.15),
          width: w * 0.3,
          height: h * 0.32),
      bellyPaint,
    );

    // Head
    canvas.drawCircle(
      Offset(cx, cy - h * 0.18),
      w * 0.22,
      bodyPaint,
    );

    // Crest/tuft on top
    final tuftPaint = Paint()..color = _bodyColorDark;
    _drawTuft(canvas, Offset(cx, cy - h * 0.38), w * 0.04, tuftPaint);

    // Beak
    _drawBeak(canvas, Offset(cx, cy - h * 0.14), w * 0.05, h * 0.04);

    // Eyes
    _drawEye(canvas, Offset(cx - w * 0.08, cy - h * 0.22), w * 0.055);
    _drawEye(canvas, Offset(cx + w * 0.08, cy - h * 0.22), w * 0.055);

    // Mood expression
    _drawExpression(canvas, Offset(cx, cy - h * 0.12), w, h);

    // Feet
    _drawFeet(canvas, Offset(cx, cy + h * 0.36), w, h);
  }

  Color get _bodyColorLight {
    switch (mood) {
      case PetMood.ecstatic:
        return const Color(0xFFFFD166);
      case PetMood.happy:
        return const Color(0xFFFF8C69);
      case PetMood.neutral:
        return const Color(0xFFFF9E7A);
      case PetMood.sad:
        return const Color(0xFF90BADC);
      case PetMood.tired:
        return const Color(0xFFB5C4D3);
    }
  }

  Color get _bodyColorDark {
    switch (mood) {
      case PetMood.ecstatic:
        return const Color(0xFFE8A020);
      case PetMood.happy:
        return const Color(0xFFE06040);
      case PetMood.neutral:
        return const Color(0xFFD87050);
      case PetMood.sad:
        return const Color(0xFF5A88B0);
      case PetMood.tired:
        return const Color(0xFF8090A0);
    }
  }

  Color get _wingColorLight {
    switch (mood) {
      case PetMood.ecstatic:
        return const Color(0xFFFFB930);
      case PetMood.happy:
        return const Color(0xFFE07050);
      case PetMood.neutral:
        return const Color(0xFFE08060);
      case PetMood.sad:
        return const Color(0xFF6898C0);
      case PetMood.tired:
        return const Color(0xFF9098A8);
    }
  }

  Color get _wingColorDark {
    switch (mood) {
      case PetMood.ecstatic:
        return const Color(0xFFC88010);
      case PetMood.happy:
        return const Color(0xFFC05030);
      case PetMood.neutral:
        return const Color(0xFFC06040);
      case PetMood.sad:
        return const Color(0xFF4070A0);
      case PetMood.tired:
        return const Color(0xFF708090);
    }
  }

  void _drawTuft(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx - r, center.dy + r * 2);
    path.lineTo(center.dx + r, center.dy + r * 2);
    path.close();
    canvas.drawPath(path, paint);
    path.reset();
    path.moveTo(center.dx - r * 0.8, center.dy + r * 0.5);
    path.lineTo(center.dx - r * 1.8, center.dy + r * 2.5);
    path.lineTo(center.dx, center.dy + r * 2);
    path.close();
    canvas.drawPath(path, paint);
    path.reset();
    path.moveTo(center.dx + r * 0.8, center.dy + r * 0.5);
    path.lineTo(center.dx + r * 1.8, center.dy + r * 2.5);
    path.lineTo(center.dx, center.dy + r * 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBeak(Canvas canvas, Offset center, double w, double h) {
    final beakPaint = Paint()..color = const Color(0xFFFFA040);
    final path = Path();
    path.moveTo(center.dx, center.dy - h * 0.5);
    path.lineTo(center.dx - w, center.dy + h);
    path.lineTo(center.dx + w, center.dy + h);
    path.close();
    canvas.drawPath(path, beakPaint);

    // Beak highlight
    final highlightPaint = Paint()..color = const Color(0xFFFFBB60);
    final highlightPath = Path();
    highlightPath.moveTo(center.dx, center.dy - h * 0.5);
    highlightPath.lineTo(center.dx - w * 0.5, center.dy + h * 0.2);
    highlightPath.lineTo(center.dx + w * 0.5, center.dy + h * 0.2);
    highlightPath.close();
    canvas.drawPath(highlightPath, highlightPaint);
  }

  void _drawEye(Canvas canvas, Offset center, double r) {
    // White of eye
    canvas.drawCircle(center, r, Paint()..color = Colors.white);

    // Iris color based on mood
    final irisColor = mood == PetMood.sad || mood == PetMood.tired
        ? const Color(0xFF6080A0)
        : const Color(0xFF4A2010);

    canvas.drawCircle(
      center.translate(r * 0.1, r * 0.1),
      r * 0.6,
      Paint()..color = irisColor,
    );

    // Pupil
    canvas.drawCircle(
      center.translate(r * 0.15, r * 0.1),
      r * 0.35,
      Paint()..color = const Color(0xFF1A0A00),
    );

    // Highlight
    canvas.drawCircle(
      center.translate(-r * 0.1, -r * 0.15),
      r * 0.18,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // Tired: draw drooping eyelid
    if (mood == PetMood.tired) {
      final lidPaint = Paint()
        ..color = _bodyColorDark
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCenter(center: center, width: r * 2, height: r * 2),
        -math.pi,
        math.pi,
        false,
        lidPaint,
      );
    }
  }

  void _drawExpression(Canvas canvas, Offset center, double w, double h) {
    if (mood == PetMood.ecstatic || mood == PetMood.happy) {
      // Rosy cheeks
      final blushPaint = Paint()
        ..color = const Color(0xFFFF8098).withValues(alpha: 0.35);
      final cx = center.dx;
      final cy = center.dy + h * 0.06;
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx - w * 0.11, cy), width: w * 0.1, height: h * 0.04),
          blushPaint);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(cx + w * 0.11, cy), width: w * 0.1, height: h * 0.04),
          blushPaint);
    }

    if (mood == PetMood.ecstatic) {
      // Happy stars / sparkles
      _drawSparkle(canvas, Offset(center.dx - w * 0.2, center.dy - h * 0.18),
          w * 0.025);
      _drawSparkle(canvas, Offset(center.dx + w * 0.22, center.dy - h * 0.15),
          w * 0.02);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double r) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      canvas.drawLine(
        center.translate(math.cos(angle) * r * 0.4, math.sin(angle) * r * 0.4),
        center.translate(math.cos(angle) * r, math.sin(angle) * r),
        paint,
      );
    }
    canvas.drawCircle(center, r * 0.3, Paint()..color = const Color(0xFFFFD700));
  }

  void _drawFeet(Canvas canvas, Offset center, double w, double h) {
    final feetPaint = Paint()
      ..color = const Color(0xFFFFA040)
      ..strokeWidth = w * 0.018
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Left foot
    final lx = center.dx - w * 0.1;
    canvas.drawLine(Offset(lx, center.dy), Offset(lx, center.dy + h * 0.07), feetPaint);
    canvas.drawLine(
        Offset(lx, center.dy + h * 0.07),
        Offset(lx - w * 0.07, center.dy + h * 0.07),
        feetPaint);
    canvas.drawLine(
        Offset(lx, center.dy + h * 0.07),
        Offset(lx + w * 0.04, center.dy + h * 0.07),
        feetPaint);

    // Right foot
    final rx = center.dx + w * 0.1;
    canvas.drawLine(Offset(rx, center.dy), Offset(rx, center.dy + h * 0.07), feetPaint);
    canvas.drawLine(
        Offset(rx, center.dy + h * 0.07),
        Offset(rx - w * 0.04, center.dy + h * 0.07),
        feetPaint);
    canvas.drawLine(
        Offset(rx, center.dy + h * 0.07),
        Offset(rx + w * 0.07, center.dy + h * 0.07),
        feetPaint);
  }

  @override
  bool shouldRepaint(_BirdPainter old) =>
      old.mood != mood || old.wingAngle != wingAngle;
}
