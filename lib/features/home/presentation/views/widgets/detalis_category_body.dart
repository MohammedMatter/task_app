import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/views/widgets/dismissible_task_item.dart';

class DetailsCategoryBody extends StatelessWidget {
  const DetailsCategoryBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskViewModel, CategoryViewModel>(
      builder: (context, provTaskViewModel, provCategoryViewModel, child) =>
          provTaskViewModel.allTasks.isEmpty ||
                  !provTaskViewModel.allTasks.map(
                    (e) {
                      return e.category.name!.toUpperCase().trim();
                    },
                  ).contains(provCategoryViewModel.selectedCategory!
                      .toUpperCase()
                      .trim())
              ? const Center(
                  child: Text('no tasks'),
                )
              : Column(children: [
                DismissibleTaskItem(
                    prov: provTaskViewModel,
                    tasks: provTaskViewModel.allTasks.where((element) {
                      return provCategoryViewModel.selectedCategory!
                              .toUpperCase().trim() ==
                          element.category.name!.toUpperCase().trim();
                    }).toList()),
              ]),
    );
  }
}
