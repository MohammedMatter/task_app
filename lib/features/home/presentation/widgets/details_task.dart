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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer3<CategoryViewModel, ThemeViewModel, TaskViewModel>(
      builder: (context, provCategoryViewModel, provThemeViewModel,
              provTaskViewModel, child) =>
          AlertDialog(
        actionsPadding: EdgeInsets.symmetric(horizontal: width * 0.03  ,vertical:height * 0.03 ),
        contentPadding: EdgeInsets.all(width * 0.04),
        actions: [
          OutlinedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.025),
                ),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'RobotoMedium',
                fontSize: width * 0.035,
                color: provThemeViewModel.nightThemeEnabled
                    ? Colors.white
                    : const Color.fromARGB(255, 41, 39, 39),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.025),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(task.statusColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                context: context,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.04,
                    right: width * 0.04,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
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
                          SizedBox(height: height * 0.015),
                          TextFormFieldStyle(
                            textEditingController: taskDescriptionController,
                            hint: task.description,
                            icon: null,
                            maxLines: 2,
                          ),
                          SizedBox(height: height * 0.02),
                          Consumer<TaskViewModel>(
                            builder: (context, prov, child) => GestureDetector(
                              onTap: () => picker.DatePicker.showDateTimePicker(
                                context,
                                onConfirm: (time) {
                                  prov.selectTime(time);
                                  task.date = prov.selectedTime!;
                                },
                                minTime: DateTime.now()
                                    .add(const Duration(minutes: 1)),
                                maxTime: DateTime(2035, 1, 1),
                                currentTime: DateTime.now()
                                    .add(const Duration(minutes: 1)),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.015),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                  color: const Color.fromARGB(255, 14, 113, 179)
                                      .withOpacity(0.15),
                                ),
                                child: Text(
                                  prov.selectedTime != null
                                      ? DateFormat('yyyy-MM-dd HH-mm')
                                          .format(prov.selectedTime!)
                                      : DateFormat('yyyy-MM-dd HH-mm')
                                          .format(task.date),
                                  style: TextStyle(fontSize: width * 0.035),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Consumer<CategoryViewModel>(
                            builder: (context, provCat, child) => Container(
                              margin: EdgeInsets.only(top: height * 0.01),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.008),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 14, 113, 179)
                                    .withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(width * 0.025),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provCat.selectedCategory ??
                                        task.category.name!,
                                    style:
                                        TextStyle(fontSize: width * 0.035),
                                  ),
                                  DropdownButton(
                                    items: provCat.categories
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e.name,
                                            child: Text(e.name!),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) =>
                                        provCat.selectCategory(value!),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Consumer<NotificationViewModel>(
                            builder:
                                (context, provNotificationViewModel, child) =>
                                    ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              leading: Icon(
                                Icons.notifications_active,
                                color: Colors.blue,
                                size: width * 0.06,
                              ),
                              title: Text(
                                'Send notifications alert',
                                style: TextStyle(
                                    fontFamily: 'RobotoLight',
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.035),
                              ),
                              trailing: Switch(
                                activeColor:
                                    const Color.fromARGB(255, 14, 113, 179),
                                value: provNotificationViewModel
                                    .tasknotificationsEnabled,
                                onChanged: (value) {
                                  provNotificationViewModel
                                      .switchTaskNotificationValue(value);
                                  task.notificationsEnabled = value;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.015),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'cancel',
                                  style: TextStyle(
                                      fontSize: width * 0.035,
                                      color:
                                          provThemeViewModel.nightThemeEnabled
                                              ? Colors.white
                                              : Colors.black),
                                ),
                              ),
                              Consumer<NotificationViewModel>(
                                builder:
                                    (context, provNotificationViewModel, child) =>
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
                                        borderRadius: BorderRadius.circular(
                                            width * 0.025),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (taskNameController.text.isNotEmpty) {
                                      task.title = taskNameController.text;
                                    }
                                    if (taskDescriptionController
                                        .text.isNotEmpty) {
                                      task.description =
                                          taskDescriptionController.text;
                                    }
                                    for (var category
                                        in provCategoryViewModel.categories) {
                                      if (category.name ==
                                          provCategoryViewModel
                                              .selectedCategory) {
                                        final color = category.color;
                                        task.category = Category(
                                          name: provCategoryViewModel
                                              .selectedCategory,
                                          color: color,
                                          description:
                                              task.category.description,
                                        );
                                      }
                                    }
                                    provTaskViewModel.selectedTime = task.date;
                                    provTaskViewModel.updateTask(task);
                                    Navigator.of(context).pop();
                                    provNotificationViewModel.sendNotification(
                                        task, task.date);
                                  } , 
                                  child: Text('save',
                                      style: TextStyle(
                                          fontSize: width * 0.035)),
                                ),
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
                fontSize: width * 0.035,
                color: provThemeViewModel.nightThemeEnabled
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.015),
              Container(
                alignment: Alignment.center,
                height: height * 0.05,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.025),
                  color: task.statusColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(EvaIcons.fileOutline,
                        color: Colors.white, size: width * 0.05),
                    SizedBox(width: width * 0.02),
                    Text(
                      'Task Details',
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.04),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              ContentOfDetails(
                icon: Icon(EvaIcons.fileOutline,
                    size: width * 0.045, color: task.statusColor),
                statusColor: task.statusColor,
                value: title,
                hint: 'Task Name : ',
              ),
              SizedBox(height: height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroIcon(HeroIcons.clipboardDocument,
                      size: width * 0.045, color: task.statusColor),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Description: ',
                            style: TextStyle(
                              color: task.statusColor,
                              fontFamily: 'RobotoMediuem',
                              fontSize: width * 0.035,
                            ),
                          ),
                          TextSpan(
                            text: task.description,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              color: provThemeViewModel.nightThemeEnabled
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: width * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              ContentOfDetails(
                icon: HeroIcon(HeroIcons.clipboardDocumentList,
                    size: width * 0.045, color: task.statusColor),
                statusColor: task.statusColor,
                value: categoryName,
                hint: 'category : ',
              ),
              SizedBox(height: height * 0.02),
              ContentOfDetails(
                icon: HeroIcon(HeroIcons.clipboardDocumentList,
                    size: width * 0.045, color: task.statusColor),
                statusColor: task.statusColor,
                value: provCategoryViewModel.categories.firstWhere(
                  (element) => element.name == task.category.name,
                  orElse: () => Category(
                    name: 'No Category',
                    color: Colors.grey,
                    description: 'No Description',
                  ),
                ).description,
                hint: 'Cat.des : ',
              ),
              SizedBox(height: height * 0.02),
              ContentOfDetails(
                icon: Icon(Icons.calendar_month_outlined,
                    size: width * 0.045, color: task.statusColor),
                statusColor: task.statusColor,
                value: DateFormat('yyyy-MM-dd').format(task.date),
                hint: 'Due Date : ',
              ),
              SizedBox(height: height * 0.02),
              ContentOfDetails(
                icon: Icon(Icons.timer_outlined,
                    size: width * 0.045, color: task.statusColor),
                statusColor: task.statusColor,
                value: DateFormat('hh:mm a').format(task.date),
                hint: 'Time : ',
              ),
              SizedBox(height: height * 0.02),
              ContentOfDetails(
                icon: Icon(Icons.notifications_active_outlined,
                    size: width * 0.045, color: task.statusColor),
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
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: width * 0.05,
      child: Row(
        children: [
          SizedBox(width: width * 0.05, child: icon),
          SizedBox(width: width * 0.015),
          Expanded(
            child: Row(
              children: [
                Text(
                  hint,
                  style: TextStyle(
                    color: statusColor,
                    fontFamily: 'RobotoMediuem',
                    fontSize: width * 0.035,
                  ),
                ),
                Expanded(
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontSize: width * 0.035),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
