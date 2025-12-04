import 'package:flutter/material.dart';
import 'package:task_app/features/auth/presentation/widgets/sign_in_body.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Scaffold(
      body: SignInBody(),
    );
  }
}
