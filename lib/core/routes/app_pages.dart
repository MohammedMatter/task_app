import 'package:flutter/material.dart';
import 'package:task_app/features/home/presentation/view/notifications_screen.dart';

import 'package:task_app/features/home/presentation/widgets/home.body.dart';
import 'package:task_app/features/home/presentation/widgets/seetings_body.dart';
import 'package:task_app/features/home/presentation/widgets/tasks_pages.dart';

abstract class AppPages {
  static List bottomNavPages = [
    const HomeBody(),
    const TasksPages(),
    Container(),
    const NotificationsScreen(),
    const SettingsBody()
  ];
}
