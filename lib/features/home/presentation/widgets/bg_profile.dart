import 'package:flutter/material.dart';

class BgProfile extends StatelessWidget {
  final double radius;
  const BgProfile({
    super.key,
    required this.radius,

  
  });

  @override
  Widget build(BuildContext context) {
    return Container(
  
     width: radius ,
     height: radius ,
     decoration: const BoxDecoration(
          
       image: 
            DecorationImage(
               image:AssetImage('assets/images/avatar_background.png',),
               fit: BoxFit.cover,
             )
         
     ),
            );
  }
}
