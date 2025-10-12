import 'package:flutter/material.dart';
import 'package:task_app/features/home/presentation/pages/notifications_screen.dart';

import 'package:task_app/features/home/presentation/views/widgets/home.body.dart';
import 'package:task_app/features/home/presentation/views/widgets/seetings_body.dart';
import 'package:task_app/features/home/presentation/views/widgets/tasks_pages.dart';

abstract class AppPages {
  static List bottomNavPages = [
    const HomeBody(),
    const TasksPages(),
    Container(),
    const NotificationsScreen(),
    const SettingsBody()
  ];
}
