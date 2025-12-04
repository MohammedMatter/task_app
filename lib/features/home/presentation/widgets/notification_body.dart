import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/home/presentation/widgets/dismussible_notification.dart';

class NotificationsBody extends StatefulWidget {
  const NotificationsBody({
    super.key,
  });

  @override
  State<NotificationsBody> createState() => _NotificationsBodyState();
}

class _NotificationsBodyState extends State<NotificationsBody> {
  @override
  void initState() {
    super.initState();
    final prov = Provider.of<NotificationViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      prov.filterNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<NotificationViewModel>(
      builder: (context, provNotificationViewModel, child) {
        return ListView(
          children: [
            if (provNotificationViewModel.notificationsTodayList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Text(
                          'Today',
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provNotificationViewModel.markAsAllRead();
                        },
                        child: Text(
                          'Mark all as read',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 13, 104, 179),
                            fontSize: width * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...provNotificationViewModel.notificationsTodayList.map(
                    (n) => Dismissiblenotification(
                      list: provNotificationViewModel.notificationsTodayList,
                      index: provNotificationViewModel.notificationsTodayList
                          .indexOf(n),
                    ),
                  ),
                ],
              ),
            if (provNotificationViewModel.notificationsYesterdayList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Text(
                          'Yesterday',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      provNotificationViewModel
                              .notificationsTodayList.isEmpty
                          ? TextButton(
                              onPressed: () {
                                provNotificationViewModel.markAsAllRead();
                              },
                              child: Text(
                                'Mark all as read',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: width * 0.035,
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  ...provNotificationViewModel.notificationsYesterdayList.map(
                    (n) => Dismissiblenotification(
                      list:
                          provNotificationViewModel.notificationsYesterdayList,
                      index: provNotificationViewModel
                          .notificationsYesterdayList
                          .indexOf(n),
                    ),
                  ),
                ],
              ),
            if (provNotificationViewModel.notificationsWeekList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Text(
                          'Last Week',
                          style: TextStyle(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      provNotificationViewModel
                                  .notificationsTodayList.isEmpty &&
                              provNotificationViewModel
                                  .notificationsYesterdayList.isEmpty
                          ? TextButton(
                              onPressed: () {
                                provNotificationViewModel.markAsAllRead();
                              },
                              child: Text(
                                'Mark all as read',
                                style: TextStyle(fontSize: width * 0.035),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  ...provNotificationViewModel.notificationsWeekList.map(
                    (n) => Dismissiblenotification(
                      list: provNotificationViewModel.notificationsWeekList,
                      index: provNotificationViewModel.notificationsWeekList
                          .indexOf(n),
                    ),
                  ),
                ],
              ),
            if (provNotificationViewModel.allNotificationsList.isEmpty)
              SizedBox(
                height: height * 0.8,
                child: const Center(
                  child: Text('No Notifications'),
                ),
              ),
          ],
        );
      },
    );
  }
}
