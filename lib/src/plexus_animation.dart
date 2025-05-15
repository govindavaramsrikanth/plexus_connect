// A customizable Flutter widget that displays a dynamic Plexus animation
// with interactive touch response and configurable parameters.

import 'dart:math';
import 'package:flutter/material.dart';

class PlexusAnimation extends StatefulWidget {
  final int pointCount;
  final double maxDistance;
  final double animationSpeed;
  final bool allowTouchInteraction;
  final Color pointColor;
  final Color lineStartColor;
  final Color lineEndColor;

  const PlexusAnimation({
    super.key,
    this.pointCount = 50,
    this.maxDistance = 100,
    this.animationSpeed = 0.05,
    this.allowTouchInteraction = true,
    this.pointColor = Colors.blueAccent,
    this.lineStartColor = Colors.blueAccent,
    this.lineEndColor = Colors.cyanAccent,
  });

  @override
  State<PlexusAnimation> createState() => _PlexusAnimationState();
}

class _PlexusAnimationState extends State<PlexusAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _points;
  late List<Offset> _velocities;
  late double _wavePhase;
  Offset? _pointer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializePlexusAnimation();
  }

  void _initializePlexusAnimation() {
    _points = List.generate(widget.pointCount, (_) => Offset.zero);
    _velocities = List.generate(widget.pointCount, (_) => Offset.zero);
    _wavePhase = 0.0;

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..addListener(_onTick)
          ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _randomizeInitialPoints(MediaQuery.of(context).size);
    });
  }

  void _randomizeInitialPoints(Size size) {
    for (int i = 0; i < widget.pointCount; i++) {
      _points[i] = Offset(
        _random.nextDouble() * size.width,
        _random.nextDouble() * size.height,
      );
      _velocities[i] = Offset(
        (_random.nextDouble() - 0.5) * 2,
        (_random.nextDouble() - 0.5) * 2,
      );
    }
  }

  void _onTick() {
    final screenSize = MediaQuery.of(context).size;
    _wavePhase += widget.animationSpeed;

    setState(() {
      _updatePointPositions(screenSize);
    });
  }

  void _updatePointPositions(Size size) {
    for (int i = 0; i < _points.length; i++) {
      final updated = _points[i] + _velocities[i];
      final dx = updated.dx;
      final dy = updated.dy;

      if (dx <= 0 || dx >= size.width) {
        _velocities[i] = Offset(-_velocities[i].dx, _velocities[i].dy);
      }
      if (dy <= 0 || dy >= size.height) {
        _velocities[i] = Offset(_velocities[i].dx, -_velocities[i].dy);
      }

      _points[i] = updated;
    }
  }

  void _handlePointer(Offset position) {
    setState(() {
      _pointer = position;
      _points.add(position);
      if (_points.length > widget.pointCount) {
        _points.removeAt(0); // Keep points within limit
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate:
          widget.allowTouchInteraction
              ? (details) => _handlePointer(details.localPosition)
              : null,
      onPanEnd: (_) => _pointer = null,
      child: CustomPaint(
        painter: _PlexusPainter(
          points: _points,
          wavePhase: _wavePhase,
          pointer: _pointer,
          maxDistance: widget.maxDistance,
          pointColor: widget.pointColor,
          lineStartColor: widget.lineStartColor,
          lineEndColor: widget.lineEndColor,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PlexusPainter extends CustomPainter {
  final List<Offset> points;
  final double wavePhase;
  final double maxDistance;
  final Offset? pointer;
  final Color pointColor;
  final Color lineStartColor;
  final Color lineEndColor;

  _PlexusPainter({
    required this.points,
    required this.wavePhase,
    required this.maxDistance,
    required this.pointColor,
    required this.lineStartColor,
    required this.lineEndColor,
    this.pointer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pointPaint =
        Paint()
          ..color = pointColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4;

    final Paint linePaint =
        Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke
          ..shader = LinearGradient(
            colors: [lineStartColor, lineEndColor],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    _drawPoints(canvas, pointPaint);
    _drawPointerHighlight(canvas, pointPaint);
    _drawConnectingCurves(canvas, linePaint);
  }

  void _drawPoints(Canvas canvas, Paint paint) {
    for (final point in points) {
      canvas.drawCircle(point, 2, paint);
    }
  }

  void _drawPointerHighlight(Canvas canvas, Paint paint) {
    if (pointer != null) {
      canvas.drawCircle(pointer!, 5, paint);
    }
  }

  void _drawConnectingCurves(Canvas canvas, Paint paint) {
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final p1 = points[i];
        final p2 = points[j];
        final distance = (p1 - p2).distance;

        if (distance < maxDistance) {
          final path = _buildWavePath(p1, p2, wavePhase, i);
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  Path _buildWavePath(Offset p1, Offset p2, double phase, int index) {
    final path = Path()..moveTo(p1.dx, p1.dy);

    final midpoint = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
    final waveHeight = 5 + 3 * sin(phase + index);

    final angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    final waveOffset = Offset(
      waveHeight * sin(angle + pi / 2),
      waveHeight * cos(angle + pi / 2),
    );

    final controlPoint = midpoint + waveOffset;
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p2.dx, p2.dy);

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
