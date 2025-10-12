import 'package:flutter/material.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About App",
          style: TextStyle(
            fontSize: width * 0.04,
            fontFamily: 'RobotoMedium',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: width * 0.1,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.task_alt,
                size: width * 0.12,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Task App",
              style: TextStyle(
                fontFamily: 'RobotoMedium',
                fontSize: width * 0.08,
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(height: height * 0.03),
            Card(
              elevation: 3,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Text(
                  "Task App is a simple and smart task management tool that helps you "
                  "organize your daily activities and receive instant or scheduled reminders. "
                  "It’s designed to be lightweight, easy to use, and reliable, so you never miss "
                  "an important task again.",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    height: 1.5,
                    fontFamily: 'RobotoMedium',
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: height * 0.05,
                  width: width * 0.45,
                  child: Text(
                    "Key Features:",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.015),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.add_task,
                      color: Colors.blue, size: width * 0.06),
                  title: Text(
                    "Add, edit, and delete tasks easily",
                    style: TextStyle(
                      fontFamily: 'RobotoMedium',
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications_active,
                      color: Colors.blue, size: width * 0.06),
                  title: Text(
                    "Smart reminders (instant & scheduled)",
                    style: TextStyle(
                      fontFamily: 'RobotoMedium',
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.view_week,
                      color: Colors.blue, size: width * 0.06),
                  title: Text(
                    "Tasks grouped by Today, Yesterday, and Week",
                    style: TextStyle(
                      fontFamily: 'RobotoMedium',
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.lightbulb,
                      color: Colors.blue, size: width * 0.06),
                  title: Text(
                    "Clean and simple user interface",
                    style: TextStyle(
                      fontFamily: 'RobotoMedium',
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.025),
            Card(
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: ListTile(
                leading: Icon(Icons.person,
                    color: Colors.blue, size: width * 0.06),
                title: Text(
                  "Developed by Eng: Mohammed Matter",
                  style: TextStyle(fontSize: width * 0.04),
                ),
                subtitle: Text(
                  "© 2025 Task App. All rights reserved.",
                  style: TextStyle(fontSize: width * 0.035),
                ),
              ),
            ),
            SizedBox(height: height * 0.015),
            Card(
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: ListTile(
                leading:
                    Icon(Icons.email, color: Colors.blue, size: width * 0.06),
                title: Text(
                  "Contact & Support",
                  style: TextStyle(fontSize: width * 0.04),
                ),
                subtitle: Text(
                  "aqelmohammed17@gmail.com",
                  style: TextStyle(fontSize: width * 0.035),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
