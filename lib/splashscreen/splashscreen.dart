import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_app/core/constants/app_images.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/features/auth/login/cubit/login_cubit.dart';
import 'package:flutter_app/features/auth/login/cubit/login_state.dart';
import 'package:flutter_app/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Drop-in + bounce entrance for the logo
  late AnimationController _dropController;
  late Animation<double> _dropAnimation; // vertical drop with bounce
  late Animation<double> _dropFade;
  late Animation<double> _dropScale;

  // Burst of particles that fire outward once logo lands
  late AnimationController _burstController;
  final List<_Particle> _particles = [];

  // Gentle continuous float (after landing)
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  // Shimmer sweep across the logo
  late AnimationController _shimmerController;

  // Text reveal
  late AnimationController _textController;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;  

  @override
  void initState() {
    super.initState();

    // Generate particle directions/distances once
    final rand = math.Random();
    for (int i = 0; i < 10; i++) {
      final angle = (i / 10) * 2 * math.pi + rand.nextDouble() * 0.3;
      _particles.add(_Particle(
        angle: angle,
        distance: 70 + rand.nextDouble() * 30,
        size: 4 + rand.nextDouble() * 4,
      ));
    }

    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    // Drops from above, overshoots slightly, settles — bounce feel
    _dropAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -220, end: 18)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 18, end: -10)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10, end: 4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 4, end: 0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 13,
      ),
    ]).animate(_dropController);

    _dropFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _dropController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // Slight squash-and-stretch on impact
    _dropScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.7, end: 1.05)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 0.92)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.92, end: 1.03)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.03, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 13,
      ),
    ]).animate(_dropController);

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _runSequence();
    _navigateToNext();
  }

  Future<void> _runSequence() async {
    await _dropController.forward(); // logo drops + bounces
    if (!mounted) return;
    _burstController.forward(); // particles burst on landing
    _shimmerController.repeat(period: const Duration(milliseconds: 1800));
    _textController.forward(); // text fades up
  }

  @override
  void dispose() {
    _dropController.dispose();
    _burstController.dispose();
    _floatController.dispose();
    _shimmerController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = SharedPref();
    bool isFirstTime = await prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, Routes.onboarding);
    } else {
      final loginCubit = context.read<LoginCubit>();
      await loginCubit.checkLoginStatus();

      if (!mounted) return;

      if (loginCubit.state.status == LoginStatus.success) {
        Navigator.pushReplacementNamed(context, Routes.main);
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E1B4B),
                    const Color(0xFF0A0F1D),
                  ]
                : [
                    const Color(0xFF1E3A8A),
                    const Color(0xFF1E40AF),
                    const Color(0xFF1D4ED8),
                  ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -100,
              child: _SoftCircle(isDark: isDark, size: 300),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: _SoftCircle(isDark: isDark, size: 200),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo zone: drop/bounce + particle burst + float + shimmer
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _dropController,
                      _burstController,
                      _floatController,
                      _shimmerController,
                    ]),
                    builder: (context, child) {
                      final landed = _dropController.isCompleted;
                      final floatOffset = landed ? _floatAnimation.value : 0.0;

                      return SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Particle burst
                            ..._particles.map((p) {
                              final t = Curves.easeOut
                                  .transform(_burstController.value);
                              final dx = math.cos(p.angle) * p.distance * t;
                              final dy = math.sin(p.angle) * p.distance * t;
                              final opacity = (1 - t).clamp(0.0, 1.0);
                              return Transform.translate(
                                offset: Offset(dx, dy),
                                child: Opacity(
                                  opacity: opacity,
                                  child: Container(
                                    width: p.size,
                                    height: p.size,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                          .withValues(alpha: 0.9),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),

                            // Impact ring (expands and fades on landing)
                            if (_burstController.value > 0)
                              Opacity(
                                opacity:
                                    (1 - _burstController.value).clamp(0.0, 1.0),
                                child: Container(
                                  width: 90 + _burstController.value * 70,
                                  height: 90 + _burstController.value * 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                            // The logo itself: drop + bounce + float
                            Transform.translate(
                              offset:
                                  Offset(0, _dropAnimation.value + floatOffset),
                              child: Transform.scale(
                                scale: _dropScale.value,
                                child: FadeTransition(
                                  opacity: _dropFade,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.blueAccent
                                                .withValues(alpha: 0.5)
                                            : Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark
                                              ? Colors.blueAccent
                                                  .withValues(alpha: 0.3)
                                              : Colors.black
                                                  .withValues(alpha: 0.1),
                                          blurRadius: 30,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                            AppImages.logo,
                                            width: 80,
                                            height: 80,
                                          ),
                                          // Shimmer sweep
                                          if (_shimmerController.isAnimating)
                                            Positioned.fill(
                                              child: Transform.translate(
                                                offset: Offset(
                                                  -80 +
                                                      _shimmerController.value *
                                                          160,
                                                  0,
                                                ),
                                                child: Transform.rotate(
                                                  angle: 0.5,
                                                  child: Container(
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.white
                                                              .withValues(
                                                                  alpha: 0.0),
                                                          Colors.white
                                                              .withValues(
                                                                  alpha: 0.35),
                                                          Colors.white
                                                              .withValues(
                                                                  alpha: 0.0),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // App name + tagline
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          const Text(
                            "Opzento HR",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Human Resource Management System",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom loading / Branding
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      l10n.powered_by,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Srivyn",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  final double angle;
  final double distance;
  final double size;

  _Particle({required this.angle, required this.distance, required this.size});
}

class _SoftCircle extends StatelessWidget {
  final bool isDark;
  final double size;

  const _SoftCircle({required this.isDark, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.blueAccent.withValues(alpha: 0.02)
            : Colors.white.withValues(alpha: 0.03),
      ),
    );
  }
}