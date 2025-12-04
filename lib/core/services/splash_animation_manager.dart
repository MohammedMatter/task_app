import 'package:flutter/material.dart';
import 'package:task_app/features/auth/presentation/view/sign_in_screen.dart';
class SplashAnimationManager {
  final TickerProvider vsync;
  AnimationController animationController;
  Animation<Offset> animation;
  BuildContext context;

  SplashAnimationManager({
    required this.vsync,
    required this.animationController,
    required this.animation,
    required this.context,
  });

  void runSplashAnimation() {
    animationController.forward();

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
          const Duration(seconds: 1),
          () => Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SignInScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
        );
      }
    });
  }
}
