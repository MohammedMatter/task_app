import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/routes/app_routes.dart';
import 'package:task_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';
import 'package:task_app/core/widgets/auth_button.dart';
import 'package:task_app/core/widgets/logo_widget.dart';
import 'package:task_app/core/widgets/text_field_style.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserViewModel, AuthViewModel>(
      builder: (context, userVM, authVM, child) {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Center(child: LogoWidget()),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black26,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormFieldStyle(
                              textEditingController: emailController,
                              hint: 'Enter your email',
                              icon: const Icon(Icons.email_outlined),
                              validator: (value) =>
                                  authVM.validateEmailLogin(
                                      email: emailController.text),
                            ),
                            const SizedBox(height: 10),
                            TextFormFieldStyle(
                              textEditingController: passwordController,
                              hint: 'Enter your password',
                              icon: const Icon(Icons.lock_outline),
                        
                              validator: (value) =>
                                  authVM.validatePassworsLogin(
                                      pass: passwordController.text),
                            ),
                            const SizedBox(height: 25),

                            // 🔹 Login Button
                            AuthButton(
                              label: 'Login',
                              method: () async {
                                if (_formKey.currentState!.validate()) {
                                  final result = await authVM.signIn(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );

                                  if (result == 'no-internet') {
                                    _showSnack(
                                      context,
                                      '⚠️ No internet connection. Check your network.',
                                      Colors.red,
                                    );
                                    return;
                                  }

                                  if (result == null) {
                                    _showSnack(
                                      context,
                                      'Email or password is incorrect.',
                                      const Color.fromARGB(255, 14, 113, 179),
                                    );
                                    return;
                                  }

                                  authVM.isLoading = false;
                                  userVM.setUser(result);
                                  Navigator.of(context)
                                      .pushReplacementNamed(AppRoutes.home);
                                }
                              },
                            ),

                            const SizedBox(height: 12),

                            // 🔹 Guest Login
                            AuthButton(
                              label: 'Login as Guest',
                              method: () async {
                                await authVM.signUpASGuest();
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.home);
                              },
                            ),

                            const SizedBox(height: 16),

                            // 🔹 Sign Up Link
                            RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 4, 55, 88),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign up',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 14, 113, 179),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .pushNamed(AppRoutes.signUp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Loading Indicator
            if (authVM.isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 14, 113, 179),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showSnack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
