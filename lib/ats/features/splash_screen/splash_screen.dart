import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';
import 'package:flutter_app/ats/features/auth/cubit/login_cubit.dart';
import 'package:flutter_app/ats/features/auth/state/login_state.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/cubit/candidate_cubit.dart';
import 'package:flutter_app/ats/utils/shared_ref.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {

  // --- Animation Controllers ---
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _rotateController;

  // --- Animations ---
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _pulse1;
  late Animation<double> _pulse2;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _rotateBg;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    navigateScreen();
  }

  void _setupAnimations() {
    // Logo pop-in
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.4)),
    );

    // Pulse rings
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pulse1 = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    _pulse2 = Tween<double>(begin: 0.8, end: 1.6).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Title slide up
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Tagline slide up (delayed)
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeIn),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Slow background rotation
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _rotateBg = Tween<double>(begin: 0, end: 2 * pi).animate(_rotateController);
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    _slideController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Future<void> navigateScreen() async {
    const storage = FlutterSecureStorage();
    final firstTime = await storage.read(key: "first_time");
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (firstTime == null) {
      await storage.write(key: "first_time", value: "done");
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    final cubit = context.read<AtsLoginCubit>();
    await cubit.checkAtsLoginStatus();
    if (!mounted) return;

    if (cubit.state.status == AtsLoginStatus.success) {
      // 🔄 UPDATE CANDIDATE CUBIT WITH SAVED SESSION BEFORE NAVIGATION
      final prefs = SharedPref();
      final sessionData = await prefs.getObject('session');
      
      if (sessionData != null && sessionData is Map && sessionData.isNotEmpty) {
        // Reconstruct OdooSession from saved data
        final session = OdooSession(
          id: sessionData['id']?.toString() ?? '',
          userId: sessionData['userId'] is int
              ? sessionData['userId']
              : int.parse(sessionData['userId']?.toString() ?? '0'),
          partnerId: sessionData['partnerId'] is int
              ? sessionData['partnerId']
              : int.parse(sessionData['partnerId']?.toString() ?? '0'),
          companyId: sessionData['companyId'] is int
              ? sessionData['companyId']
              : int.parse(sessionData['companyId']?.toString() ?? '0'),
          allowedCompanies: const <Company>[],
          userLogin: sessionData['userLogin']?.toString() ?? '',
          userName: sessionData['userName']?.toString() ?? '',
          userLang: sessionData['userLang']?.toString() ?? "en_US",
          userTz: sessionData['userTz']?.toString() ?? "UTC",
          isSystem: sessionData['isSystem'] is bool ? sessionData['isSystem'] : false,
          dbName: sessionData['dbName']?.toString() ?? 'ftprotech',
          serverVersion: sessionData['serverVersion']?.toString() ?? "",
        );
        
        // Update CandidateCubit with saved session and reload data
        if (mounted) {
          await context.read<CandidateCubit>().setSessionAndRefresh(session);
        }
      }
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.recruitermainlayout);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── 1. Indigo Gradient Background ──
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1a1a6e),
                  const Color(0xFF3B82F6),
                  Color(0xFF3949AB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── 2. Rotating decorative orbs ──
          AnimatedBuilder(
            animation: _rotateBg,
            builder: (context, _) {
              return Stack(
                children: [
                  Positioned(
                    top: -size.width * 0.3,
                    right: -size.width * 0.2,
                    child: Transform.rotate(
                      angle: _rotateBg.value,
                      child: Container(
                        width: size.width * 0.8,
                        height: size.width * 0.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -size.width * 0.25,
                    left: -size.width * 0.15,
                    child: Transform.rotate(
                      angle: -_rotateBg.value,
                      child: Container(
                        width: size.width * 0.7,
                        height: size.width * 0.7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.06),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── 3. Floating dots pattern ──
          ...List.generate(12, (i) {
            final random = Random(i * 7);
            final x = random.nextDouble() * size.width;
            final y = random.nextDouble() * size.height;
            final radius = random.nextDouble() * 3 + 1;
            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            );
          }),

          // ── 4. Center Content ──
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulse rings + Logo
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 180,
                      height: 180,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer pulse ring
                          FadeTransition(
                            opacity: Tween<double>(begin: 0.4, end: 0.0)
                                .animate(_pulseController),
                            child: Transform.scale(
                              scale: _pulse2.value,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Inner pulse ring
                          FadeTransition(
                            opacity: Tween<double>(begin: 0.6, end: 0.0)
                                .animate(_pulseController),
                            child: Transform.scale(
                              scale: _pulse1.value,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Logo circle
                          ScaleTransition(
                            scale: _logoScale,
                            child: FadeTransition(
                              opacity: _logoFade,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.15),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.people_alt_rounded,
                                  size: 52,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // App Name
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: const Text(
                      "Opzento ATS",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Tagline
                SlideTransition(
                  position: _taglineSlide,
                  child: FadeTransition(
                    opacity: _taglineFade,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Text(
                        "Smart Hiring · Better Future",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 70),

                // Loading indicator
                FadeTransition(
                  opacity: _taglineFade,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          color: Colors.white.withValues(alpha: 0.85),
                          strokeWidth: 2.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Initializing...",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.55),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── 5. Bottom brand strip ──
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _taglineFade,
              child: Center(
                child: Text(
                  "Powered by Opzento",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
