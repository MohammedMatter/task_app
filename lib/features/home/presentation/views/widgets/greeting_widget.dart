import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<UserViewModel>(
      builder: (context, provUserViewMidel, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hi,',
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: width * 0.01),
                  SizedBox(
                    width: width * 0.28,
                    child: Text(
                      provUserViewMidel.user?.name ?? 'User',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: width * 0.02),
              Text(
                'Have a nice day !',
                style: TextStyle(
                  color: const Color.fromARGB(255, 129, 128, 128),
                  fontSize: width * 0.033,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
