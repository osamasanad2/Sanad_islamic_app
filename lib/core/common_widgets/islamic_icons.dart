import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom Islamic-themed icon widgets drawn with CustomPainter
class IslamicIcons {
  IslamicIcons._();

  /// Prayer beads (Tasbeeh) icon
  static Widget tasbeeh({double size = 28, Color color = const Color(0xFF1B5E20)}) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _TasbeehPainter(color)));
  }

  /// Open Quran with ornamental bookmark
  static Widget quran({double size = 28, Color color = const Color(0xFF1B5E20)}) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _QuranPainter(color)));
  }

  /// Sun with octagonal Islamic frame (Azkar)
  static Widget azkar({double size = 28, Color color = const Color(0xFF1B5E20)}) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _AzkarPainter(color)));
  }
}

// ─── Tasbeeh (Prayer Beads) ───
class _TasbeehPainter extends CustomPainter {
  final Color color;
  _TasbeehPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final beadPaint = Paint()..color = color..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.2;
    final stringPaint = Paint()..color = color.withValues(alpha: 0.4)..style = PaintingStyle.stroke..strokeWidth = 1.0;

    // String circle (the thread)
    final r = size.width * 0.34;
    canvas.drawCircle(c, r, stringPaint);

    // Draw beads around the circle
    const beadCount = 10;
    final beadR = size.width * 0.06;
    for (int i = 0; i < beadCount; i++) {
      final angle = (i * 2 * math.pi / beadCount) - math.pi / 2;
      final bx = c.dx + r * math.cos(angle);
      final by = c.dy + r * math.sin(angle);
      canvas.drawCircle(Offset(bx, by), beadR, beadPaint);
    }

    // Tassel at top
    final tasselTop = Offset(c.dx, c.dy - r - beadR);
    final tasselEnd = Offset(c.dx, c.dy - r - size.width * 0.22);
    canvas.drawLine(tasselTop, tasselEnd, Paint()..color = color..strokeWidth = 1.5..strokeCap = StrokeCap.round);
    // Tassel head (larger ornamental bead)
    canvas.drawCircle(tasselEnd, beadR * 1.5, beadPaint);
    canvas.drawCircle(tasselEnd, beadR * 1.5, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Quran (Open Book with Ornament) ───
class _QuranPainter extends CustomPainter {
  final Color color;
  _QuranPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final goldPaint = Paint()..color = const Color(0xFFD4AF37)..style = PaintingStyle.fill;

    // Left page
    final leftPage = Path()
      ..moveTo(w * 0.5, h * 0.18)
      ..quadraticBezierTo(w * 0.25, h * 0.15, w * 0.1, h * 0.2)
      ..lineTo(w * 0.1, h * 0.82)
      ..quadraticBezierTo(w * 0.25, h * 0.78, w * 0.5, h * 0.82)
      ..close();
    canvas.drawPath(leftPage, Paint()..color = color.withValues(alpha: 0.15));
    canvas.drawPath(leftPage, stroke);

    // Right page
    final rightPage = Path()
      ..moveTo(w * 0.5, h * 0.18)
      ..quadraticBezierTo(w * 0.75, h * 0.15, w * 0.9, h * 0.2)
      ..lineTo(w * 0.9, h * 0.82)
      ..quadraticBezierTo(w * 0.75, h * 0.78, w * 0.5, h * 0.82)
      ..close();
    canvas.drawPath(rightPage, Paint()..color = color.withValues(alpha: 0.1));
    canvas.drawPath(rightPage, stroke);

    // Spine line
    canvas.drawLine(Offset(w * 0.5, h * 0.18), Offset(w * 0.5, h * 0.82), stroke);

    // Text lines (left page)
    final linePaint = Paint()..color = color.withValues(alpha: 0.35)..strokeWidth = 0.8..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final y = h * (0.35 + i * 0.1);
      canvas.drawLine(Offset(w * 0.18, y), Offset(w * 0.44, y), linePaint);
    }
    // Text lines (right page)
    for (int i = 0; i < 4; i++) {
      final y = h * (0.35 + i * 0.1);
      canvas.drawLine(Offset(w * 0.56, y), Offset(w * 0.82, y), linePaint);
    }

    // Gold bookmark ribbon
    final ribbon = Path()
      ..moveTo(w * 0.68, h * 0.18)
      ..lineTo(w * 0.68, h * 0.05)
      ..lineTo(w * 0.73, h * 0.12)
      ..lineTo(w * 0.78, h * 0.05)
      ..lineTo(w * 0.78, h * 0.18);
    canvas.drawPath(ribbon, goldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Azkar (Sun with Octagonal Frame) ───
class _AzkarPainter extends CustomPainter {
  final Color color;
  _AzkarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final stroke = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final goldPaint = Paint()..color = const Color(0xFFD4AF37)..style = PaintingStyle.fill;

    // Outer octagonal frame
    final outerR = size.width * 0.42;
    final outerPath = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8) - math.pi / 8;
      final px = c.dx + outerR * math.cos(angle);
      final py = c.dy + outerR * math.sin(angle);
      if (i == 0) outerPath.moveTo(px, py); else outerPath.lineTo(px, py);
    }
    outerPath.close();
    canvas.drawPath(outerPath, Paint()..color = color.withValues(alpha: 0.1));
    canvas.drawPath(outerPath, stroke);

    // Inner star pattern (8-pointed)
    final innerR = size.width * 0.28;
    final starR = size.width * 0.16;
    final starPath = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi * 2 / 16) - math.pi / 2;
      final r = i.isEven ? innerR : starR;
      final px = c.dx + r * math.cos(angle);
      final py = c.dy + r * math.sin(angle);
      if (i == 0) starPath.moveTo(px, py); else starPath.lineTo(px, py);
    }
    starPath.close();
    canvas.drawPath(starPath, goldPaint);

    // Center sun circle
    canvas.drawCircle(c, size.width * 0.1, fill);

    // Sun rays (tiny lines poking out)
    final rayPaint = Paint()..color = color..strokeWidth = 1.2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8);
      final from = Offset(c.dx + size.width * 0.12 * math.cos(angle), c.dy + size.width * 0.12 * math.sin(angle));
      final to = Offset(c.dx + size.width * 0.15 * math.cos(angle), c.dy + size.width * 0.15 * math.sin(angle));
      canvas.drawLine(from, to, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
