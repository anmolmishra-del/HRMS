import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_app/ats/features/forget_password/presention/forget_password_page.dart';
import 'package:flutter_app/ats/routes/app_routes.dart';
import 'package:flutter_app/ats/features/auth/state/login_state.dart';
import 'package:flutter_app/ats/features/candidatefolder/candidate/cubit/candidate_cubit.dart';
import 'package:flutter_app/ats/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_app/ats/utils/shared_ref.dart';
import '../cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocConsumer<AtsLoginCubit, AtsLoginState>(
        listener: (context, state) async {
          if (state.status == AtsLoginStatus.success) {
            // 🔄 UPDATE CANDIDATE CUBIT WITH NEW SESSION BEFORE NAVIGATION
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
              
              // Update CandidateCubit and RecruiterProfileCubit in the background
              if (!context.mounted) return;
              context.read<CandidateCubit>().setSessionAndRefresh(session);
              context.read<RecruiterProfileCubit>().getProfile();
            }
            
            // Navigate to main layout immediately (removing the 3-second block)
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(context, AppRoutes.recruitermainlayout);
          }
          if (state.status == AtsLoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red.shade400,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AtsLoginCubit>();

          return SingleChildScrollView(
            child: Stack(
              children: [
                // 1. Deep Purple Gradient Header
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: CircleAvatar(
                          radius: 120,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: -30,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      // Welcome Text
                      const Positioned(
                        top: 100,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Please sign in to your account",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Floating Form Card
                Padding(
                  padding: const EdgeInsets.only(top: 240, left: 24, right: 24, bottom: 40),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // EMAIL FIELD
                        _buildLabel("Email Address"),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: emailController,
                          hint: "Enter your email",
                          icon: Icons.email_outlined,
                          errorText: state.usernameError,
                        ),
                        
                        const SizedBox(height: 24),

                        // PASSWORD FIELD
                        _buildLabel("Password"),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: passwordController,
                          hint: "Enter your password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          obscureText: state.obscurePassword,
                          errorText: state.passwordError,
                          onToggleVisibility: cubit.togglePasswordVisibility,
                        ),

                        const SizedBox(height: 16),

                        // REMEMBER ME & FORGOT PASSWORD
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: state.rememberMe,
                                    activeColor: const Color(0xFF3B82F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (value) {
                                      cubit.toggleRememberMe(value!);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Remember me",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: const Color(0xFF3B82F6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // LOGIN BUTTON
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              cubit.onUsernameChanged(emailController.text);
                              cubit.onPasswordChanged(passwordController.text);
                              cubit.login(
                                usernameErrorMsg: 'Email is required',
                                passwordErrorMsg: 'Password is required',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: state.status == AtsLoginStatus.loading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // DIVIDER
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Powered by Srivyn",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                          ],
                        ),

                        // const SizedBox(height: 24),

                        // // SOCIAL BUTTONS
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     _socialButton(
                        //       image: AppImage.google,
                        //       onTap: () {
                        //         debugPrint("Google Login");
                        //       },
                        //     ),
                        //     const SizedBox(width: 20),
                        //     _socialButton(
                        //       image: AppImage.micro,
                        //       onTap: () {
                        //         debugPrint("Microsoft Login");
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    String? errorText,
    VoidCallback? onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        errorText: errorText,
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade500,
                  size: 22,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: const Color(0xFF3B82F6), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }

  Widget _socialButton({
    required String image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            image,
            height: 26,
            width: 26,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
