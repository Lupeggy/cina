import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const GoogleLogo({
    Key? key,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(
        color: color ?? const Color(0xFF4285F4),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  final Color color;

  _GoogleLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double width = size.width;
    final double height = size.height;

    // Draw the blue background
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(2.0),
      ),
      bluePaint,
    );

    // Draw the red part
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    canvas.drawCircle(
      Offset(width * 0.3, height * 0.3),
      width * 0.2,
      redPaint,
    );

    // Draw the blue part
    final bluePartPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.5, height * 0.1, width * 0.4, height * 0.4),
        const Radius.circular(8.0),
      ),
      bluePartPaint,
    );

    // Draw the green part
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.1, height * 0.6, width * 0.8, height * 0.3),
        const Radius.circular(4.0),
      ),
      greenPaint,
    );

    // Draw the yellow part
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(width * 0.1, height * 0.1, width * 0.3, height * 0.6),
        const Radius.circular(4.0),
      ),
      yellowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
