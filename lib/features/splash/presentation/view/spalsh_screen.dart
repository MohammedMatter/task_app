import 'package:flutter/material.dart';
import 'package:task_app/core/services/splash_animation_manager.dart';

import 'package:task_app/features/splash/presentation/views/widgets/splash_body.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SpalshScreenState();
}
class _SpalshScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late SplashAnimationManager _splashAnimationManager;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.easeOutCubic));
    _splashAnimationManager = SplashAnimationManager(
        vsync: this,
        animationController: _animationController,
        animation: _animation,
        context: context);
    _splashAnimationManager.runSplashAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBody(animation: _animation),
    );
  }
}
