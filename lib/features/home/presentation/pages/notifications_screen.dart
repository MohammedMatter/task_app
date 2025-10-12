import 'package:flutter/material.dart';
import 'package:task_app/features/home/presentation/views/widgets/notification_body.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: width * 0.05,
            fontFamily: 'RobotoMedium',
          ),
        ),
      ),
      body: const NotificationsBody(),
    );
  }
}
