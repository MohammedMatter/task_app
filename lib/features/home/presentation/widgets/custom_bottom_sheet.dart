import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/data/models/category.dart';
import 'package:task_app/features/home/data/models/notification.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/core/widgets/text_field_style.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';

void customBottomSheet(
    BuildContext context,
    double hightScreen,
    double widthScreen,
    TaskViewModel prov,
    CategoryViewModel provCategoryViewModel,
    TextEditingController taskNameController,
    TextEditingController taskDescriptionController) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(widthScreen * 0.05),
          ),
          child: Padding(
            padding: EdgeInsets.all(widthScreen * 0.04),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormFieldStyle(
                    maxLines: 2,
                    minLines: 2,
                    textEditingController: taskNameController,
                    hint: 'Task Name',
                    icon: null,
                  ),
                  TextFormFieldStyle(
                    maxLines: 2,
                    minLines: 2,
                    textInputType: TextInputType.multiline,
                    textEditingController: taskDescriptionController,
                    hint: 'Description',
                    icon: null,
                  ),
                  SizedBox(height: hightScreen * 0.01),
                  GestureDetector(
                    onTap: () => picker.DatePicker.showDateTimePicker(
                      onConfirm: (time) {
                        prov.selectTime(time);
                      },
                      context,
                      minTime: DateTime.now().add(const Duration(minutes: 1)),
                      maxTime: DateTime(2035, 1, 1),
                      currentTime: DateTime.now().add(const Duration(minutes: 1)),
                    ),
                    child: Consumer<TaskViewModel>(
                      builder: (context, prov, child) => Container(
                        padding: EdgeInsets.only(
                            top: hightScreen * 0.015, left: widthScreen * 0.04),
                        height: hightScreen * 0.06,
                        width: widthScreen,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(widthScreen * 0.03)),
                          color: const Color.fromARGB(255, 14, 113, 179)
                              .withOpacity(0.15),
                        ),
                        child: Text(
                          prov.selectedTime != null
                              ? DateFormat('yyyy-MM-dd HH:mm')
                                  .format(prov.selectedTime!)
                              : 'Select Time & Date',
                          style: TextStyle(fontSize: widthScreen * 0.035),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: hightScreen * 0.015),
                  Consumer<CategoryViewModel>(
                    builder: (context, provCategoryViewModel, child) => Container(
                      margin: EdgeInsets.only(top: hightScreen * 0.01),
                      padding: EdgeInsets.symmetric(
                        horizontal: widthScreen * 0.04,
                        vertical: hightScreen * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 14, 113, 179)
                            .withOpacity(0.15),
                        borderRadius:
                            BorderRadius.all(Radius.circular(widthScreen * 0.03)),
                      ),
                      child: SizedBox(
                        height: hightScreen * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provCategoryViewModel.selectedCategory ??
                                  'Select Category',
                              style: TextStyle(fontSize: widthScreen * 0.035),
                            ),
                            DropdownButton(
                              items: provCategoryViewModel.categories
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(
                                        e.name!,
                                        style:
                                            TextStyle(fontSize: widthScreen * 0.035),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  provCategoryViewModel.selectCategory(value!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Consumer<NotificationViewModel>(
                    builder:
                        (context, provNotificationViewModel, child) => ListTile(
                      leading: Icon(
                        Icons.notifications_active,
                        color: Colors.blue,
                        size: widthScreen * 0.06,
                      ),
                      title: Text(
                        'Send notifications alert',
                        style: TextStyle(
                          fontFamily: 'RobotoLight',
                          fontWeight: FontWeight.bold,
                          fontSize: widthScreen * 0.038,
                        ),
                      ),
                      trailing: Switch(
                        activeColor: const Color.fromARGB(255, 14, 113, 179),
                        value: provNotificationViewModel.tasknotificationsEnabled,
                        onChanged: (value) {
                          provNotificationViewModel
                              .switchTaskNotificationValue(value);
                        },
                      ),
                    ),
                  ),
                  Consumer<NotificationViewModel>(
                    builder:
                        (context, provNotificationViewModel, child) => SizedBox(
                      width: widthScreen,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widthScreen * 0.04),
                            ),
                          ),
                          minimumSize: WidgetStatePropertyAll(
                            Size(double.infinity, hightScreen * 0.07),
                          ),
                        ),
                        onPressed: () async {
                          if (taskNameController.text.isNotEmpty &&
                              taskDescriptionController.text.isNotEmpty &&
                              provCategoryViewModel.selectedCategory != null) {
                            prov.addToUpcomingTasks(
                              prov: provNotificationViewModel,
                              createdAt: DateTime.now(),
                              notificationEnabled:
                                  provNotificationViewModel.tasknotificationsEnabled,
                              title: taskNameController.text,
                              description: taskDescriptionController.text,
                              date: prov.selectedTime ?? DateTime.now(),
                              category: Category(
                                description:
                                    provCategoryViewModel.categories[0].description,
                                id: '0',
                                name: provCategoryViewModel.selectedCategory,
                                color: provCategoryViewModel.categories
                                    .firstWhere(
                                      (element) =>
                                          provCategoryViewModel.selectedCategory !=
                                                  null
                                              ? provCategoryViewModel
                                                      .selectedCategory!
                                                      .toUpperCase()
                                                      .trim() ==
                                                  element.name!.toUpperCase().trim()
                                              : false,
                                      orElse: () => Category(
                                        description:
                                            taskDescriptionController.text,
                                        name: '',
                                        color: const Color.fromARGB(
                                            255, 139, 179, 74),
                                        id: '',
                                      ),
                                    )
                                    .color,
                              ),
                              status: 'UpComing',
                            );

                            if (provNotificationViewModel
                                .tasknotificationsEnabled) {
                              provNotificationViewModel.addNotification(
                                await prov.authRepository.getUid(),
                                NotificationApp(
                                  duaAt: prov.selectedTime ?? DateTime.now(),
                                  type: 'scheduled',
                                  isRead: false,
                                  body: taskDescriptionController.text,
                                  title: taskNameController.text,
                                  timestamp: DateTime.now(),
                                ),
                              );
                            }

                            Navigator.pop(context);
                          } else {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                        fontSize: widthScreen * 0.045,
                                        color: const Color.fromARGB(
                                            255, 14, 113, 179),
                                      ),
                                    ),
                                  ),
                                ],
                                title: Text(
                                  'Error!',
                                  style: TextStyle(
                                      fontSize: widthScreen * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  taskNameController.text.isEmpty
                                      ? 'Please enter the task name.'
                                      : taskDescriptionController.text.isEmpty
                                          ? 'Please enter the task description.'
                                          : provCategoryViewModel
                                                  .categories.isEmpty
                                              ? 'You must add a category and then add a task.'
                                              : 'Please enter the task category.',
                                  style:
                                      TextStyle(fontSize: widthScreen * 0.04),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: widthScreen * 0.04),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ).whenComplete(() {
    taskNameController.clear();
    provCategoryViewModel.selectedCategory = null;
    taskDescriptionController.clear();
  });
}
