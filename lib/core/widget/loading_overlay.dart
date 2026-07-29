import 'package:flutter/material.dart';

class AppPendulumLoader extends StatefulWidget {
  final double size;
  const AppPendulumLoader({super.key, this.size = 60});

  @override
  State<AppPendulumLoader> createState() => _AppPendulumLoaderState();
}

class _AppPendulumLoaderState extends State<AppPendulumLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Using a curved animation that mimics gravity deceleration at the peaks
    _animation = Tween<double>(begin: -0.5, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          alignment: Alignment.topCenter, // Pivot at the top to act like a pendulum!
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The "string" of the pendulum
              Container(
                width: 2,
                height: widget.size * 0.5,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
              // The app logo as the bob of the pendulum
              Container(
                width: widget.size * 0.9,
                height: widget.size * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/opsen.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback icon in case image is missing
                      return Icon(
                        Icons.blur_circular,
                        size: widget.size * 0.9,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15),
              child: const Center(
                child: AppPendulumLoader(
                  size: 100,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AppLoader extends StatelessWidget {
  final double size;
  const AppLoader({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppPendulumLoader(size: size),
    );
  }
}
