import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/core/constants/app_colors.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';
import 'package:flutter_app/ats/features/signup/cubit/signup_cubit.dart';
import 'package:flutter_app/ats/features/signup/state/signup_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Sign up'),
          backgroundColor: AppColors.secondary,
        ),
        body: SafeArea(
          child: BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state.status == SignupStatus.success) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text(state.message)),
                // );

                // Navigate to login page after successful signup
                Navigator.pushReplacementNamed(context, AppRoutes.recruitermainlayout);
              }

              if (state.status == SignupStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },

            builder: (context, state) {
              final cubit = context.read<SignupCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Create account',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('Please enter your details to create an account'),
                    const SizedBox(height: 24),

                    const Text('Full name'),
                    const SizedBox(height: 8),
                    TextField(controller: nameController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                    const SizedBox(height: 16),

                    const Text('Email'),
                    const SizedBox(height: 8),
                    TextField(controller: emailController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                    const SizedBox(height: 16),

                    const Text('Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: state.obscurePassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: Icon(state.obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: cubit.togglePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text('Confirm Password'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: confirmController,
                      obscureText: state.obscureConfirmPassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: Icon(state.obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: cubit.toggleConfirmPassword,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state.status == SignupStatus.loading
                            ? null
                            : () {
                                cubit.signup(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  confirmPassword: confirmController.text,
                                );
                              },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: state.status == SignupStatus.loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign up', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
