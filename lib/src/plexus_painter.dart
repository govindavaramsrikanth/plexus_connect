import 'dart:math';
import 'package:flutter/material.dart';

/// Custom painter that draws animated Plexus-style connections between points.
class PlexusPainter extends CustomPainter {
  final List<Offset> points;
  final double wavePhase;
  final double maxDistance;
  final Offset? pointer;
  final Color pointColor;
  final Color lineStartColor;
  final Color lineEndColor;

  PlexusPainter({
    required this.points,
    required this.wavePhase,
    this.pointer,
    this.maxDistance = 100,
    required this.pointColor,
    required this.lineStartColor,
    required this.lineEndColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = _buildPointPaint();
    final linePaint = _buildLinePaint(size);

    _drawPoints(canvas, pointPaint);
    _drawPointer(canvas, pointPaint);
    _drawConnections(canvas, linePaint);
  }

  /// Creates a paint object for drawing points.
  Paint _buildPointPaint() {
    return Paint()
      ..color = pointColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;
  }

  /// Creates a gradient paint for connecting lines.
  Paint _buildLinePaint(Size size) {
    final gradient = LinearGradient(
      colors: [lineStartColor, lineEndColor],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    return Paint()
      ..shader = gradient
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
  }

  /// Draws all points in the list.
  void _drawPoints(Canvas canvas, Paint paint) {
    for (var point in points) {
      canvas.drawCircle(point, 2, paint);
    }
  }

  /// Draws the pointer circle if it is available.
  void _drawPointer(Canvas canvas, Paint paint) {
    if (pointer != null) {
      canvas.drawCircle(pointer!, 5, paint);
    }
  }

  /// Draws curvy lines between nearby points with wave animation.
  void _drawConnections(Canvas canvas, Paint paint) {
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final p1 = points[i];
        final p2 = points[j];
        final distance = (p1 - p2).distance;

        if (distance < maxDistance) {
          final path = _createWavePath(p1, p2, i);
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  /// Creates a quadratic Bezier path with wave distortion between two points.
  Path _createWavePath(Offset p1, Offset p2, int index) {
    final midPoint = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
    final waveHeight = 5 + 3 * sin(wavePhase + index); // Animated wave
    final angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);

    // Calculate control point offset perpendicular to the line
    final waveOffset = Offset(
      waveHeight * sin(angle + pi / 2),
      waveHeight * cos(angle + pi / 2),
    );

    final controlPoint = midPoint + waveOffset;

    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p2.dx, p2.dy);
    return path;
  }

  @override
  bool shouldRepaint(covariant PlexusPainter oldDelegate) {
    return true; // Repaint every frame to support animation
  }
}
