import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.25,
      width: width * 0.7,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logo_image.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
