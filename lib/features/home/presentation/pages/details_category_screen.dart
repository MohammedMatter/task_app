import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/data/models/task.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/views/widgets/detalis_category_body.dart';

// ignore: must_be_immutable
class CategoryDetailsPage extends StatelessWidget {
  CategoryDetailsPage({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer2<CategoryViewModel, TaskViewModel>(
      builder: (context, provCategoryViewModel, provtaskViewModel, child) =>
          Scaffold(
        appBar: AppBar(
          title: Text(
            provCategoryViewModel.selectedCategory ?? '',
            style: TextStyle(fontSize: width * 0.045),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: PopupMenuButton(
                color: const Color.fromARGB(255, 14, 113, 179),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.edit, color: Colors.white),
                      title: const Text(
                        'edit category',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SizedBox(
                              height: height * 0.25,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: provCategoryViewModel
                                              .selectedCategory ??
                                          'No Selected Category',
                                    ),
                                  ),
                                  SizedBox(height: height * 0.015),
                                  TextField(
                                    controller: desController,
                                    decoration: InputDecoration(
                                      hintText: provCategoryViewModel
                                          .categories
                                          .firstWhereOrNull(
                                            (element) =>
                                                element.name!.toLowerCase() ==
                                                provCategoryViewModel
                                                    .selectedCategory!
                                                    .toLowerCase(),
                                          )
                                          ?.description,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: const Text('Warning'),
                            actions: [
                              TextButton(
                                child: const Text('Done'),
                                onPressed: () {
                                  for (var element
                                      in provCategoryViewModel.categories) {
                                    if (element.name!.toUpperCase() ==
                                        provCategoryViewModel
                                            .selectedCategory!
                                            .toUpperCase()) {
                                      provCategoryViewModel.updateCategory(
                                        newName: nameController.text,
                                        newDecription: desController.text,
                                        idCategory: element.id!,
                                      );

                                      List<Task> newTasksList =
                                          provtaskViewModel.allTasks
                                              .where(
                                                (element) =>
                                                    element.category.name!
                                                        .toUpperCase() ==
                                                    provCategoryViewModel
                                                        .selectedCategory!
                                                        .toUpperCase(),
                                              )
                                              .toList();

                                      provtaskViewModel.updateCategoryTasks(
                                        color: element.color,
                                        description: desController.text,
                                        name: nameController.text,
                                        tasks: newTasksList,
                                      );
                                    }
                                  }

                                  provCategoryViewModel
                                      .selectCategory(nameController.text);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text(
                          'If you delete, it will delete all tasks related to this category.',
                        ),
                        title: const Text('Warning'),
                        actions: [
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              provCategoryViewModel.deleteCategory(
                                provCategoryViewModel.categories.firstWhere(
                                  (element) =>
                                      element.name ==
                                      provCategoryViewModel.selectedCategory,
                                ),
                              );

                              provtaskViewModel.allTasks.where((e) {
                                return e.category.name!.contains(
                                  provCategoryViewModel.selectedCategory!,
                                );
                              }).map((e) {
                                return provtaskViewModel.deleteTask(e);
                              }).toList();

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.delete, color: Colors.white),
                      title: Text(
                        'delete category',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: const DetailsCategoryBody(),
          ),
        ),
      ),
    );
  }
}
