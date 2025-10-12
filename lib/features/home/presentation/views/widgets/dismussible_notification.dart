import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/data/models/notification.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';

class Dismissiblenotification extends StatelessWidget {
  int index;
  List<NotificationApp> list;
  Dismissiblenotification({
    super.key,
    required this.list,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<NotificationViewModel>(
      builder: (context, provNotificationViewModel, child) => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            provNotificationViewModel.removeNotification(
              list[index],
            );
          }
        },
        background: Container(
          padding: EdgeInsets.only(right: width * 0.12),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width * 0.06),
              color: const Color.fromARGB(255, 14, 113, 179)),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: width * 0.06,
          ),
        ),
        direction: DismissDirection.endToStart,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                provNotificationViewModel.markAsRead(
                  list[index],
                );
              },
              trailing: list[index].isRead
                  ? const SizedBox.shrink()
                  : CircleAvatar(
                      radius: width * 0.013,
                      backgroundColor: Colors.green,
                    ),
              leading: Text(
                '🗓️ ',
                style: TextStyle(fontSize: width * 0.05),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.35,
                        child: Text(
                          list[index].title!,
                          style: TextStyle(
                              fontSize: width * 0.035,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Text(
                        '– due at : ${DateFormat('hh-mm a').format(list[index].duaAt)}',
                        style: TextStyle(fontSize: width * 0.035),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DateTime.now()
                                  .difference(list[index].timestamp!)
                                  .inMinutes ==
                              0
                          ? Text(
                              '1 min ago',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: width * 0.03),
                            )
                          : DateTime.now()
                                      .difference(list[index].timestamp!)
                                      .inMinutes <
                                  60
                              ? Text(
                                  DateTime.now()
                                              .difference(
                                                  list[index].timestamp!)
                                              .inHours <
                                          60
                                      ? '${DateTime.now().difference(list[index].timestamp!).inMinutes} minutes ago'
                                      : '${{
                                          DateTime.now()
                                              .difference(
                                                  list[index].timestamp!)
                                              .inHours
                                        }} hours ago',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: width * 0.03),
                                )
                              : Text(
                                  DateTime.now()
                                              .difference(
                                                  list[index].timestamp!)
                                              .inHours >
                                          24
                                      ? '${DateTime.now().difference(list[index].timestamp!).inDays} days ago'
                                      : '${DateTime.now().difference(list[index].timestamp!).inHours} hours ago',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: width * 0.03),
                                ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(thickness: height * 0.0007)
          ],
        ),
      ),
    );
  }
}
