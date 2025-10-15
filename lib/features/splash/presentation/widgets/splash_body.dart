import 'package:flutter/material.dart';
import 'package:task_app/core/widgets/logo_widget.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({
    super.key,
    required Animation<Offset> animation,
  }) : _animation = animation;

  final Animation<Offset> _animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideTransition(
        position: _animation,
        child: LogoWidget(),
      ),
    );
  }
}

