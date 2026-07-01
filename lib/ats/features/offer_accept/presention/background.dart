import 'package:flutter/material.dart';

class ConfettiBackground extends StatelessWidget {
  const ConfettiBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(
          40,
          (index) {
            return Positioned(
              left: (index * 17).toDouble() % 350,
              top: (index * 35).toDouble() % 650,
              child: Transform.rotate(
                angle: index.toDouble(),
                child: Container(
                  width: 6,
                  height: 14,
                  decoration: BoxDecoration(
                    color: [
                      Colors.orange,
                      Colors.pink,
                      Colors.green,
                      Colors.purple,
                      Colors.yellow,
                    ][index % 5],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
