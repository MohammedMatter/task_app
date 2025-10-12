import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/routes/app_routes.dart';
import 'package:task_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';
import 'package:task_app/core/widgets/auth_button.dart';
import 'package:task_app/core/widgets/logo_widget.dart';
import 'package:task_app/core/widgets/text_field_style.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, UserViewModel>(
      builder: (context, provAuthViewModel, provUserViewMidel, child) => Form(
        key: _key,
        child: Stack(
          children: [
            provAuthViewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 14, 113, 179),
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    const Center(child: LogoWidget()),
                    Column(
                      children: [
                        TextFormFieldStyle(
                          validator: (name) =>
                              provAuthViewModel.validateName(name ?? ''),
                          textEditingController: nameController,
                          hint: 'Enter your name',
                          icon: const Icon(Icons.person_2_outlined),
                        ),
                        TextFormFieldStyle(
                          validator: (email) =>
                              provAuthViewModel.validateEmail(email ?? ''),
                          textEditingController: emailController,
                          hint: 'Enter E-mail',
                          icon: const Icon(Icons.email_outlined),
                        ),
                        TextFormFieldStyle(
                          validator: (pass) =>
                              provAuthViewModel.validatePassword(pass ?? ""),
                          textEditingController: passwordController,
                          hint: 'Enter your password',
                          icon: const Icon(Icons.visibility),
                        ),
                        TextFormFieldStyle(
                          validator: (confPass) =>
                              provAuthViewModel.validateConfirmPassword(
                                  passwordController.text, confPass!),
                          hint: 'Confirm password',
                          icon: const Icon(Icons.visibility_off),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    AuthButton(
                      method: () async {
                        if (_key.currentState!.validate()) {
                          final authViewModel = context.read<AuthViewModel>();

                          final auth = await authViewModel.signUp(
                            emailController.text,
                            passwordController.text,
                            nameController.text,
                          );

                  
                          if (auth == 'no-internet') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    '⚠️ No internet connection. Check your network.'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }

                     
                          if (auth == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor:
                                    Color.fromARGB(255, 14, 113, 179),
                                content: Text(
                                  'The email is already in use. Please choose another one.',
                                ),
                              ),
                            );
                            return;
                          }

      
                          provUserViewMidel.setUser(auth);
                          Navigator.of(context).pushNamed(AppRoutes.home);
                        }
                      },
                      label: 'Sign Up',
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await provAuthViewModel.signInWithGoogle();
                          Navigator.of(context).pushNamed('/Home');
                        },
                        style: ButtonStyle(
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.black),
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 40,
                              child: Image.asset(
                                'assets/images/google.png',
                              ),
                            ),
                            const Text('Sign In with Google'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.signIn);
                      },
                      child: const Text(
                        'You have an account ? ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 14, 113, 179),
                        ),
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
