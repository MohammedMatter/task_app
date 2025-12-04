import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/data/models/task.dart';
import 'package:task_app/features/home/presentation/view/home_screen.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/theme_view_model.dart';
import 'package:task_app/features/home/presentation/widgets/details_task.dart';

class DismissibleTaskItem extends StatelessWidget {
  List<Task> tasks;
  TaskViewModel prov;
  DismissibleTaskItem({
    required this.prov,
    required this.tasks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer3<NotificationViewModel, CategoryViewModel, ThemeViewModel>(
      builder: (context, provNotificationViewModel, provCategoryViewModel,
              provThemeViewModel, child) =>
          Container(
        alignment: Alignment.center,
        child: tasks.isEmpty
            ? SizedBox(
                height: height * 0.08,
                child: Center(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                              height: height * 0.045,
                              child: Image.asset(
                                'assets/images/icon_no_task.png',
                              )),
                          Text(
                            "No tasks yet",
                            style: TextStyle(
                                fontSize: width * 0.038, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: tasks
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.all(width * 0.013),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => detailsTask(
                                      title: e.title,
                                      task: e,
                                      categoryName: e.category.name,
                                    ));
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            key: UniqueKey(),
                            background: Container(
                              padding:
                                  EdgeInsets.only(right: width * 0.12),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.06),
                                  color: const Color.fromARGB(255, 14, 113, 179)),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: width * 0.06,
                              ),
                            ),
                            child: Container(
                              height: height * 0.15,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          provThemeViewModel.nightThemeEnabled
                                              ? const Color.fromARGB(
                                                      255, 151, 150, 150)
                                                  .withOpacity(0.12)
                                              : const Color.fromARGB(
                                                      255, 78, 75, 75)
                                                  .withOpacity(0.12),
                                      blurRadius: width * 0.025,
                                      spreadRadius: 0.1,
                                      offset: Offset(width * 0.01, height * 0.01),
                                    )
                                  ],
                                  color: provThemeViewModel.nightThemeEnabled
                                      ? Theme.of(context).cardColor
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  borderRadius:
                                      BorderRadius.circular(width * 0.06)),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(width * 0.06),
                                        bottomLeft:
                                            Radius.circular(width * 0.06)),
                                    child: Container(
                                      width: width * 0.13,
                                      color: e.statusColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            e.statusName == 'InProgress'
                                                ? Icons.autorenew
                                                : e.statusName == 'Done'
                                                    ? Icons.done
                                                    : Icons.schedule,
                                            color: Colors.white,
                                            size: width * 0.06,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.02),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 0.45,
                                          child: Text(
                                            maxLines: 1,
                                            e.title,
                                            style: TextStyle(
                                                decorationThickness: 3,
                                                decoration: e.statusName ==
                                                        'Done'
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                fontSize: width * 0.045,
                                                fontFamily: 'RobotoMediuem',
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.43,
                                          child: Text(
                                            maxLines: 1,
                                            e.description,
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                fontSize: width * 0.042,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 156, 153, 153),
                                                fontFamily: 'RobotoMediuem'),
                                          ),
                                        ),
                                        Consumer<CategoryViewModel>(
                                          builder: (context,
                                                  provCategoryViewModel,
                                                  child) =>
                                              Text(
                                            'Category : ${e.category.name ?? 'No Category Selected'}',
                                            style: TextStyle(
                                                fontFamily: 'RobotoMediuem',
                                                fontSize: width * 0.035,
                                                fontWeight: FontWeight.bold,
                                                color: e.category.color),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timer_outlined,
                                              size: width * 0.04,
                                            ),
                                            SizedBox(width: width * 0.01),
                                            Text(
                                              DateFormat(
                                                'yyyy-M-dd   HH-mm a',
                                              ).format(e.date),
                                              style: TextStyle(
                                                  fontSize: width * 0.035,
                                                  fontFamily:
                                                      'RobotoMediuem'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  indexGlobal == 0
                                      ? const Spacer()
                                      : const SizedBox.shrink(),
                                  tasks == prov.allTasks
                                      ? Expanded(
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.01,
                                                  vertical: height * 0.005),
                                              decoration: BoxDecoration(
                                                  color: e.statusColor!
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              width * 0.05))),
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                e.statusName!,
                                                style: TextStyle(
                                                    color: e.statusColor!,
                                                    fontSize:
                                                        width * 0.035),
                                              )),
                                        )
                                      : e.statusName != 'Done'
                                          ? Expanded(
                                              child: PopupMenuButton(
                                                  onSelected: (value) {
                                                prov.deleteTask(e);
                                                e.statusName == 'UpComing'
                                                    ? prov.addToInProgressTasks(
                                                        createdAt:
                                                            DateTime.now(),
                                                        notificationsEnabled:
                                                            provNotificationViewModel
                                                                .tasknotificationsEnabled,
                                                        title: e.title,
                                                        description:
                                                            e.description,
                                                        date: e.date,
                                                        category: e.category,
                                                        status: 'InProgress',
                                                      )
                                                    : prov.addToDoneTasks(
                                                        createdAt:
                                                            DateTime.now(),
                                                        notificationsEnabled:
                                                            provNotificationViewModel
                                                                .tasknotificationsEnabled,
                                                        title: e.title,
                                                        description:
                                                            e.description,
                                                        date: e.date,
                                                        category: e.category,
                                                        status: 'Done');
                                              }, itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                      value: e.statusName ==
                                                              'UpComing'
                                                          ? 'Move to InProgress'
                                                          : 'Move to Done',
                                                      child: Text(
                                                          e.statusName ==
                                                                  'UpComing'
                                                              ? 'Move to InProgress'
                                                              : 'Move to Done'))
                                                ];
                                              }),
                                            )
                                          : const SizedBox.shrink(),
                                  SizedBox(width: width * 0.05),
                                ],
                              ),
                            ),
                            onDismissed: (direction) async {
                              if (direction ==
                                  DismissDirection.endToStart) {
                                prov.deleteTask(e);
                              }
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
