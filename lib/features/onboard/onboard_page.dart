import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/core/constants/app_images.dart';
import 'package:flutter_app/core/widget/custome_button.dart';
import 'package:flutter_app/core/utils/shared_pref.dart';
import 'package:flutter_app/features/auth/login_screen.dart';
import 'package:flutter_app/core/localization/locale_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  Future<void> _goToMain() async {
    final prefs = SharedPref();
    await prefs.saveBool('isFirstTime', false);
    
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, _) => const LoginScreen(),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleCubit>().state;
    final l10n = AppLocalizations.of(context)!;

    final List<OnboardingData> pages = [
      OnboardingData(
        title: l10n.welcome_title,
        subtitle: l10n.welcome_subtitle,
        image: 'assets/images/ob1.png',
      ),
      OnboardingData(
        title: l10n.attendance_payroll,
        subtitle: l10n.attendance_payroll_subtitle,
        image: 'assets/images/ob2.png',
      ),
       OnboardingData(
        title: 'Manage Work with Ease',
        subtitle: 'Track attendance, access payroll, complete tasks, and stay productive anywhere.',
        image: 'assets/images/ob3.png',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Background Decoration
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF0F7FF)],
                ),
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: _buildCircle(300, Colors.blue.withValues(alpha: 0.05)),
          ),
          Positioned(
            bottom: 50,
            left: -50,
            child: _buildCircle(200, Colors.blue.withValues(alpha: 0.03)),
          ),

          SafeArea(
            child: Column(
              children: [
                // ⏭️ Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextButton(
                      onPressed: _goToMain,
                      child: Text(
                        l10n.skip,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),

                // 📄 PageView Content
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(pages[index]);
                    },
                  ),
                ),

                // 🎛️ Bottom Controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => _buildIndicator(index, langCode),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomGradientButton(
                          text: _currentPage == pages.length - 1
                              ? l10n.get_started
                              : l10n.next_step,
                          onPressed: () {
                            if (_currentPage < pages.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _goToMain();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

 Widget _buildIndicator(int index, String langCode) {
  bool active = _currentPage == index;

  return AnimatedContainer(
    duration: const Duration(milliseconds: 350),
    margin: const EdgeInsets.symmetric(horizontal: 5),
    width: active ? 28 : 10,
    height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: active
          ? const LinearGradient(
              colors: [
                Color(0xFF1E3A8A),
                Color(0xFF2563EB),
              ], 
            )
          : null,
      color: active ? null : Colors.grey.shade300,
    ),
  );
}

 Widget _buildPage(OnboardingData data) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: [
        const Spacer(),

        // Illustration
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 320,
              width: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1976D2).withOpacity(.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Hero(
              tag: data.image,
              child: Image.asset(
                data.image,
                height: 330,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
            height: 1.2,
          ),
        ),

        const SizedBox(height: 18),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.7,
            ),
          ),
        ),

        const Spacer(),
      ],
    ),
  );
 }}
class OnboardingData {
  final String title;
  final String subtitle;
  final String image;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
