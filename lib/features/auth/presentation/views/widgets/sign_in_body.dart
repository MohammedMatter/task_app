
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
  const SignInBody({
    super.key,
  });

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Consumer2<UserViewModel, AuthViewModel>(
        builder: (context, provUserViewMidel, provAuthViewModel, child) =>
            Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Center(child: LogoWidget()),
                  const Text(
                    'Welcome back !',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      height: 330,
                      width: 300,
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  TextFormFieldStyle(
                                    validator: (value) =>
                                        provAuthViewModel.validateEmailLogin(
                                            email: emailController.text),
                                    textEditingController: emailController,
                                    hint: 'Enter your email',
                                    icon: const Icon(Icons.email),
                                  ),
                                  TextFormFieldStyle(
                                    validator: (value) =>
                                        provAuthViewModel.validatePassworsLogin(
                                            pass: passwordController.text),
                                    textEditingController: passwordController,
                                    hint: 'Enter your password',
                                    icon: const Icon(Icons.visibility_off),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Consumer<AuthViewModel>(
                                    builder:
                                        (context, provAuthViewModel, child) =>
                                            AuthButton(
                         method: () async {
                if (formKey.currentState!.validate()) {
                  final auth = await provAuthViewModel.signIn(
                    emailController.text,
                    passwordController.text,
                  );
              
                
                  if (auth == 'no-internet') {
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('⚠️ No internet connection. Check your network.'),
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
                        backgroundColor: Color.fromARGB(255, 14, 113, 179),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: Text('Email or password is incorrect.'),
                      ),
                    );
                    return;
                  }
              
              
                  provAuthViewModel.isLoading = false;
                   provUserViewMidel.setUser(auth);
                  Navigator.of(context).pushNamed(AppRoutes.home);
                }
              },
              
                                      label: 'Login',
                                    ),
                                  ),
                                  AuthButton(
                                    method: () async {
                                      final authModel =
                                          Provider.of<AuthViewModel>(context,
                                              listen: false);
                                      await authModel.signUpASGuest();
                                      Navigator.of(context)
                                          .pushNamed(AppRoutes.home);
                                    },
                                    label: 'Login as Guest',
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                    text: 'Don\'t have an account ?',
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
                                              color: Color.fromARGB(
                                                  255, 14, 113, 179)),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                         Navigator.of(context).pushNamed(AppRoutes.signUp) ; 
                                            })
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
            provAuthViewModel.isLoading
                ? const Center(child: CircularProgressIndicator(color:  Color.fromARGB(255, 14, 113, 179)  ,))
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
