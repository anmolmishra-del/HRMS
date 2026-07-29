import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/features/forget_password/cubit/forget_password_cubit.dart';
import 'package:flutter_app/ats/features/forget_password/state/forget_password_state.dart';


class ForgotPasswordPage
    extends StatefulWidget {

  const ForgotPasswordPage({
    super.key,
  });

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {

  final emailController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) =>
          ForgotPasswordCubit(),

      child: Scaffold(

        appBar: AppBar(
          title: const Text(
            "Forgot Password",
          ),
        ),

        body: BlocConsumer<
            ForgotPasswordCubit,
            ForgotPasswordState>(

          listener: (context, state) {

            if (state.status ==
                ForgotPasswordStatus.success) {

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                SnackBar(
                  content:
                      Text(state.message),
                ),
              );

              Navigator.pop(context);
            }

            if (state.status ==
                ForgotPasswordStatus.error) {

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                SnackBar(
                  content:
                      Text(state.message),
                ),
              );
            }
          },

          builder: (context, state) {

            final cubit =
                context.read<
                    ForgotPasswordCubit>();

            return Padding(

              padding:
                  const EdgeInsets.all(24),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const SizedBox(height: 30),

                  const Text(

                    "Reset Password",

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Enter your email to receive reset password link",
                  ),

                  const SizedBox(height: 40),

                  TextField(

                    controller:
                        emailController,

                    decoration:
                        InputDecoration(

                      labelText: "Email",

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                                14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(

                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(

                      onPressed: () {

                        cubit.sendResetLink(
                          email:
                              emailController
                                  .text,
                        );
                      },
style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,

      foregroundColor: Colors.white,

      elevation: 5,

      shadowColor:
          Colors.deepPurple.withOpacity(0.4),

      shape: RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(16),
      ),

      padding:
          const EdgeInsets.symmetric(
        vertical: 14,
      ),

),
                      child:
                          state.status ==
                                  ForgotPasswordStatus.loading

                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                )

                              : const Text(
                                  "Send Reset Link",style: TextStyle(color: AppColors.background,fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
