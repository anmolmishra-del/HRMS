import 'dart:math' as math;

import 'package:flutter/material.dart';

class ConfettiParticle {
  Color color;
  double x;
  double y;
  double size;
  double speedY;
  double speedX;
  double rotation;
  double rotationSpeed;

  ConfettiParticle({
    required this.color,
    required this.x,
    required this.y,
    required this.size,
    required this.speedY,
    required this.speedX,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ConfettiAnimationWidget extends StatefulWidget {
  const ConfettiAnimationWidget({super.key});

  @override
  State<ConfettiAnimationWidget> createState() => _ConfettiAnimationWidgetState();
}

class _ConfettiAnimationWidgetState extends State<ConfettiAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();
  
  final List<Color> _colors = [
    Colors.pink,
    Colors.amber,
    Colors.lightBlue,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.deepOrangeAccent,
    Colors.yellowAccent,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 70; i++) {
      _particles.add(ConfettiParticle(
        color: _colors[_random.nextInt(_colors.length)],
        x: _random.nextDouble(),
        y: _random.nextDouble() * -0.6 - 0.1, // Start off-screen above
        size: _random.nextDouble() * 10 + 6,
        speedY: _random.nextDouble() * 4 + 3,
        speedX: _random.nextDouble() * 3 - 1.5,
        rotation: _random.nextDouble() * 2 * math.pi,
        rotationSpeed: _random.nextDouble() * 0.15 - 0.075,
      ));
    }
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
        // Update particles
        for (var p in _particles) {
          p.y += p.speedY * 0.003;
          p.x += (p.speedX + math.sin(p.y * 5) * 0.5) * 0.002;
          p.rotation += p.rotationSpeed;

          // Recycle particle if it goes off bottom
          if (p.y > 1.1) {
            p.y = -0.1;
            p.x = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: ConfettiPainter(particles: _particles),
        );
      },
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      paint.color = p.color;
      final px = p.x * size.width;
      final py = p.y * size.height;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation);

      // Randomly draw squares or circles
      if (p.size % 2 == 0) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.5),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size * 0.3, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
