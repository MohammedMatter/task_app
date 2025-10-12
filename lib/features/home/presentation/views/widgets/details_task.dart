import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/data/models/category.dart';
import 'package:task_app/features/home/data/models/task.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/theme_view_model.dart';
import 'package:task_app/core/widgets/text_field_style.dart';

// ignore: must_be_immutable
class detailsTask extends StatelessWidget {
  Task task;
  String? title;

  String? categoryName;
  detailsTask({
    required this.task,
    required this.categoryName,
    required this.title,
    super.key,
  });

  TextEditingController taskNameController = TextEditingController();

  TextEditingController taskDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {final responsiveValue = MediaQuery.of(context).size.width * 0.04;

    return Consumer3<CategoryViewModel, ThemeViewModel, TaskViewModel>(
      builder: (context, provCategoryViewModel, provThemeViewModel,
              provTaskViewModel, child) =>
          AlertDialog(
        actions: [
          OutlinedButton(
              style: const ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: 'RobotoMedium',
                    color: provThemeViewModel.nightThemeEnabled
                        ? Colors.white
                        : const Color.fromARGB(255, 41, 39, 39)),
              )),
          ElevatedButton(
              style: ButtonStyle(
                  shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
                  backgroundColor: WidgetStatePropertyAll(task.statusColor)),
              onPressed: () {
                Navigator.of(context).pop();
                showModalBottomSheet(
                  
                  context: context,
                  builder: (context) => Padding(
                    padding:  EdgeInsets.only(top: responsiveValue , left: responsiveValue , right: responsiveValue , bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormFieldStyle(
                              textEditingController: taskNameController,
                              hint: title,
                              icon: null,
                            ),
                            TextFormFieldStyle(
                              textEditingController: taskDescriptionController,
                              hint: task.description,
                              icon: null,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Consumer<TaskViewModel>(
                              builder: (context, prov, child) =>
                                  GestureDetector(
                                onTap: () =>
                                    picker.DatePicker.showDateTimePicker(
                                  onConfirm: (time) {
                                    prov.selectTime(time);
                                    task.date = prov.selectedTime!;
                                  },
                                  context,
                                  minTime: DateTime.now()
                                      .add(const Duration(minutes: 1)),
                                  maxTime: DateTime(2035, 1, 1),
                                  currentTime: DateTime.now()
                                      .add(const Duration(minutes: 1)),
                                ),
                                child: Consumer<TaskViewModel>(
                                  builder: (context, prov, child) => Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15),
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: const Color.fromARGB(
                                              255, 14, 113, 179)
                                          .withOpacity(0.15),
                                    ),
                                    child: Text(prov.selectedTime != null
                                        ? DateFormat('yyyy-MM-dd HH-mm')
                                            .format(prov.selectedTime!)
                                        : DateFormat('yyyy-MM-dd HH-mm')
                                            .format(task.date)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Consumer<CategoryViewModel>(
                              builder:
                                  (context, provCategoryViewModel, child) =>
                                      Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 14, 113, 179)
                                      .withOpacity(0.15),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(provCategoryViewModel
                                              .selectedCategory ??
                                          task.category.name!),
                                      DropdownButton(
                                        items: provCategoryViewModel.categories
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e.name,
                                                child: Text(e.name!),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) =>
                                            provCategoryViewModel
                                                .selectCategory(value!),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Consumer<NotificationViewModel>(
                                  builder: (context, provNotificationViewModel,
                                          child) =>
                                      ListTile(
                                    leading: const Icon(
                                      Icons.notifications_active,
                                      color: Colors.blue,
                                    ),
                                    title: const Text(
                                      'Send notifications alert',
                                      style: TextStyle(
                                          fontFamily: 'RobotoLight',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Switch(
                                      activeColor: Colors.blue,
                                      value: provNotificationViewModel
                                          .tasknotificationsEnabled,
                                      onChanged: (value) {
                                        provNotificationViewModel
                                            .switchTaskNotificationValue(value);
                                        task.notificationsEnabled = value;
                                      },
                                    ),
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'cancel',
                                      style: TextStyle(
                                          color: provThemeViewModel
                                                  .nightThemeEnabled
                                              ? const Color.fromARGB(
                                                  255, 255, 255, 255)
                                              : const Color.fromARGB(
                                                  255, 0, 0, 0)),
                                    )),
                                Consumer<NotificationViewModel>(
                                  builder: (context, provNotificationViewModel,
                                          child) =>
                                      TextButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                const WidgetStatePropertyAll(
                                                    Colors.white),
                                            backgroundColor:
                                                const WidgetStatePropertyAll(
                                                    Colors.blue),
                                            shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                          ),
                                          onPressed: () async {
                                            if (taskNameController
                                                .text.isNotEmpty) {
                                              log('${taskNameController.text.isNotEmpty}');
                                              task.title =
                                                  taskNameController.text;
                                              log(task.title);
                                            }
                                            if (taskDescriptionController
                                                .text.isNotEmpty) {
                                              task.description =
                                                  taskDescriptionController
                                                      .text;
                                            }
                                            for (var category
                                                in provCategoryViewModel
                                                    .categories) {
                                              if (category.name ==
                                                  provCategoryViewModel
                                                      .selectedCategory) {
                                                final color = category.color;
                                                task.category = Category(
                                                    name: provCategoryViewModel
                                                        .selectedCategory,
                                                    color: color,
                                                    description: task
                                                        .category.description);
                                              }
                                            }
                                            provTaskViewModel.selectedTime =
                                                task.date;
                                            provTaskViewModel.updateTask(task);
                                            Navigator.of(context).pop();
                                            provNotificationViewModel
                                                .sendNotification(
                                                    task, task.date);
                                          },
                                          child: const Text('save')),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                'Edit Task',
                style: TextStyle(
                    fontFamily: 'RobotoMedium',
                    color: provThemeViewModel.nightThemeEnabled
                        ? Colors.black
                        : Colors.white),
              )),
        ],
        content: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: task.statusColor),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      EvaIcons.fileOutline,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Task Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ContentOfDetails(
                icon: Icon(
                  size: 17,
                  EvaIcons.fileOutline,
                  color: task.statusColor,
                ),
                statusColor: task.statusColor,
                value: title,
                hint: 'Task Name : ',
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroIcon(
                      size: 17,
                      HeroIcons.clipboardDocument,
                      color: task.statusColor),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Description: ',
                            style: TextStyle(
                                color: task.statusColor,
                                fontFamily: 'RobotoMediuem'),
                          ),
                          TextSpan(
                            text: task.description,
                            style: TextStyle(
                                color: provThemeViewModel.nightThemeEnabled
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: 'RobotoMediuem'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ContentOfDetails(
                icon: HeroIcon(
                  size: 17,
                  HeroIcons.clipboardDocumentList,
                  color: task.statusColor,
                ),
                statusColor: task.statusColor,
                value: categoryName,
                hint: 'category : ',
              ),
              const SizedBox(
                height: 15,
              ),
              ContentOfDetails(
                icon: HeroIcon(
                  size: 17,
                  HeroIcons.clipboardDocumentList,
                  color: task.statusColor,
                ),
                statusColor: task.statusColor,
                value: provCategoryViewModel.categories.firstWhere(
                  (element) {
                    log('/*${element.description}');
                    return element.name == task.category.name;
                  },
                  orElse: () => Category(
                      name: 'No Category',
                      color: Colors.grey,
                      description: 'No Description'),
                ).description,
                hint: 'Cat.des : ',
              ),
              const SizedBox(
                height: 15,
              ),
              ContentOfDetails(
                icon: Icon(
                  size: 17,
                  Icons.calendar_month_outlined,
                  color: task.statusColor,
                ),
                statusColor: task.statusColor,
                value: DateFormat('yyyy-MM-dd').format(task.date),
                hint: 'Due Date : ',
              ),
              const SizedBox(
                height: 15,
              ),
              ContentOfDetails(
                icon: Icon(
                  size: 17,
                  Icons.timer_outlined,
                  color: task.statusColor,
                ),
                statusColor: task.statusColor,
                value: DateFormat('hh:mm a').format(task.date),
                hint: 'Time : ',
              ),
              const SizedBox(
                height: 15,
              ),
              ContentOfDetails(
                icon: Icon(
                  size: 17,
                  Icons.notifications_active_outlined,
                  color: task.statusColor,
                ),
                statusColor: task.statusColor,
                value: task.notificationsEnabled ? 'Enabled' : 'Disabled',
                hint: 'Notification : ',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ContentOfDetails extends StatelessWidget {
  String hint;
  var icon;
  final Color? statusColor;
  var value;
  ContentOfDetails({
    required this.icon,
    super.key,
    required this.hint,
    required this.statusColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          SizedBox(width: 20, child: icon),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            child: SizedBox(
              height: 20,
              child: Row(
                children: [
                  Text(
                    hint,
                    style: TextStyle(
                        color: statusColor, fontFamily: 'RobotoMediuem'),
                  ),
                  Expanded(
                      child: Text(
                    value.toString(),
                    style: const TextStyle(fontFamily: 'RobotoMediuem'),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
