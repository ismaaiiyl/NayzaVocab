import 'package:flutter/material.dart';

class NayzaIcon extends StatelessWidget {
  final double size;
  final Color color;

  const NayzaIcon({
    super.key,
    this.size = 24.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TridentPainter(color: color),
    );
  }
}

class _TridentPainter extends CustomPainter {
  final Color color;

  _TridentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Center spear (longer)
    canvas.drawLine(Offset(w * 0.5, h * 0.1), Offset(w * 0.5, h * 0.9), paint);
    
    // Left prong
    final leftPath = Path()
      ..moveTo(w * 0.5, h * 0.45)
      ..quadraticBezierTo(w * 0.2, h * 0.45, w * 0.25, h * 0.2);
    canvas.drawPath(leftPath, paint);

    // Right prong
    final rightPath = Path()
      ..moveTo(w * 0.5, h * 0.45)
      ..quadraticBezierTo(w * 0.8, h * 0.45, w * 0.75, h * 0.2);
    canvas.drawPath(rightPath, paint);

    // Bottom decorative ring
    canvas.drawCircle(Offset(w * 0.5, h * 0.85), size.width * 0.05, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
