import 'package:flutter/material.dart';
import 'package:task_app/features/auth/presentation/views/widgets/sign_up_body.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        body: SignUpBody());
  }
}
