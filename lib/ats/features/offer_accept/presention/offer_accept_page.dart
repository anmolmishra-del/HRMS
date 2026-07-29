import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';

import 'package:flutter_app/ats/features/offer_accept/cubit/offer_accept_cubit.dart';
import 'package:flutter_app/ats/features/offer_accept/repository/repository.dart';
import 'package:flutter_app/ats/features/offer_accept/state/offer_accept_state.dart';

class OfferAcceptedPage extends StatefulWidget {
  const OfferAcceptedPage({super.key});

  @override
  State<OfferAcceptedPage> createState() =>
      _OfferAcceptedPageState();
}

class _OfferAcceptedPageState
    extends State<OfferAcceptedPage>
    with TickerProviderStateMixin {

  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  late AnimationController tickController;
  late Animation<double> tickAnimation;

  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();

    /// SUCCESS CARD ANIMATION
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    scaleAnimation = CurvedAnimation(
      parent: scaleController,
      curve: Curves.elasticOut,
    );

    /// GREEN TICK ANIMATION
    tickController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    tickAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: tickController,
        curve: Curves.easeOutBack,
      ),
    );

    /// CONFETTI
    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    scaleController.forward();
    tickController.forward();
    confettiController.play();
  }

  @override
  void dispose() {
    scaleController.dispose();
    tickController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OfferAcceptedCubit(
            OfferRepository(),
          )..loadOfferDetails(),

      child: Scaffold(
        // backgroundColor: Colors.white,

        body: SafeArea(
          child: BlocBuilder<
              OfferAcceptedCubit,
              OfferAcceptedState>(
            builder: (context, state) {

              if (state is OfferAcceptedLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is OfferAcceptedLoaded) {

                return Stack(
                  children: [

                    /// LEFT CONFETTI
                    Align(
                      alignment: Alignment.topLeft,
                      child: ConfettiWidget(
                        confettiController:
                            confettiController,
                        blastDirection: 0.5,
                        emissionFrequency: 0.05,
                        numberOfParticles: 20,
                        gravity: 0.2,
                      ),
                    ),

                    /// RIGHT CONFETTI
                    Align(
                      alignment: Alignment.topRight,
                      child: ConfettiWidget(
                        confettiController:
                            confettiController,
                        blastDirection: 2.5,
                        emissionFrequency: 0.05,
                        numberOfParticles: 20,
                        gravity: 0.2,
                      ),
                    ),

                    /// BACK BUTTON
                    // Positioned(
                    //   top: 20,
                    //   left: 10,
                    //   child: IconButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //     icon: const Icon(
                    //       Icons.arrow_back_ios_new,
                    //       size: 28,
                    //     ),
                    //   ),
                    // ),

                    /// MAIN CONTENT
                    Center(
                      child: ScaleTransition(
                        scale: scaleAnimation,

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                          Spacer(),
                              /// GREEN SUCCESS ICON
                              Container(
                                width: 100,
                                height: 100,
                              
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                              
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.green
                                  //         .withOpacity(0.4),
                                  //     blurRadius: 25,
                                  //     spreadRadius: 5,
                                  //   ),
                                  // ],
                                ),
                              
                               child: Container(
                                //   width: 140,
                                // height: 140,
                              
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                              
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      blurRadius: 25,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                 child: TweenAnimationBuilder<double>(
                                   tween: Tween(begin: 0, end: 1),
                                   duration: const Duration(milliseconds: 900),
                                   curve: Curves.easeOutBack,
                                 
                                   builder: (context, value, child) {
                                      final opacity =
                                         value.clamp(0.0, 1.0);
                                     return Transform.scale(
                                       scale: value,
                                       child: Opacity(
                                         opacity: opacity,
                                         child: Icon(
                                           Icons.check_rounded,
                                           color: Colors.white,
                                           size: 60 * value,
                                         ),
                                       ),
                                     );
                                   },
                                 ),
                               ),
                              ),
                          
                              const SizedBox(height: 30),
                          
                              TweenAnimationBuilder<Color?>(
                            tween: ColorTween(
                              begin: Colors.black,
                              end: Colors.green,
                            ),
                          
                            duration: const Duration(
                              milliseconds: 1200,
                            ),
                          
                            builder: (context, color, child) {
                              return Text(
                                'Congratulations!',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              );
                            },
                          ),
                          
                              const SizedBox(height: 10),
                          
                              Text(
                                state.model.candidateName,
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                          
                              // const SizedBox(height: 5),
                          
                              const Text(
                                'has accepted the offer',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                          
                              const SizedBox(height: 50),
                          
                              const Text(
                                'Joining Date',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                          
                              const SizedBox(height: 10),
                          
                           Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 12,
  ),

  decoration: BoxDecoration(
    color: Colors.white,

    borderRadius: BorderRadius.circular(14),

    border: Border.all(
      color: AppColors.shadow,
      width: 1.2,
    ),

    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),

  child: Text(
    state.model.joiningDate,
    textAlign: TextAlign.center,

    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors. success
    ),
  ),
),
                          
                           const Spacer(),
                          const SizedBox(height: 20),
                          
                              Container(
                                width: 320,
                                height: 58,
                          
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(14),
                          color: AppColors.secondary
                                  // gradient:
                                  //     const LinearGradient(
                                  //   colors: [
                                  //     Color(0xFF7B61FF),
                                  //     Color(0xFF5B3FFF),
                                  //   ],
                                  // ),
                                ),
                          
                                child: ElevatedButton(
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.transparent,
                                    shadowColor:
                                        Colors.transparent,
                                  ),
                                  onPressed: () {},
                          
                                  child: const Text(
                                    'View Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (state is OfferAcceptedError) {
                return Center(
                  child: Text(state.message),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
