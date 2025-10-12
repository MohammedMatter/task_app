import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';

// ignore: must_be_immutable
class AuthButton extends StatelessWidget {
  String? label;
  VoidCallback? method;
  AuthButton({
    this.method,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Consumer<UserViewModel>(
      builder: (context, provUserViewMidel, child) => SizedBox(
        width: width,
        height: height * 0.065,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.03),
              ),
            ),
          ),
          onPressed: method,
          child: Text(
            label!,
            style: TextStyle(
              color: Colors.white,
              fontSize: width * 0.045,
              fontFamily: 'RobotoMedium',
            ),
          ),
        ),
      ),
    );
  }
}
