import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/filter_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/search_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/views/widgets/bg_profile.dart';
import 'package:task_app/features/home/presentation/views/widgets/category_selector.dart';
import 'package:task_app/features/home/presentation/views/widgets/dismissible_task_item.dart';
import 'package:task_app/features/home/presentation/views/widgets/greeting_widget.dart';
import 'package:task_app/features/home/presentation/views/widgets/search_task.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer4<TaskViewModel, SearchViewModel, CategoryViewModel,
        FilterViewModel>(
      builder: (context, provTask, provSearch, provCategoryViewModel,
              provFilter, child) =>
          Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.015),
              Row(
                children: [
                  SizedBox(width: width * 0.012),
                  BgProfile(radius: width * 0.1),
                  SizedBox(width: width * 0.02),
                  const GreetingWidget(),
                ],
              ),
              SizedBox(height: height * 0.015),
              const SearchTask(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontFamily: 'RobotoMedium',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   CategorySelector(),
                  provFilter.searchType.name == 'task' &&
                          provTask.allTasks.any(
                            (element) =>
                                element.title.toUpperCase().trim() ==
                                provSearch.taskName.toUpperCase().trim(),
                          )
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.025),
                            DismissibleTaskItem(
                              tasks: provTask.allTasks
                                  .where(
                                    (e) =>
                                        e.title.toUpperCase().trim() ==
                                        provSearch.taskName
                                            .toUpperCase()
                                            .trim(),
                                  )
                                  .toList(),
                              prov: provTask,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(width * 0.05),
                              child: Text(
                                'Upcoming Tasks',
                                style: TextStyle(
                                  fontSize: width * 0.042,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RobotoMedium',
                                ),
                              ),
                            ),
                            DismissibleTaskItem(
                              tasks: provTask.upcomingTasks,
                              prov: provTask,
                            ),
                            Padding(
                              padding: EdgeInsets.all(width * 0.05),
                              child: Text(
                                'InProgress Tasks',
                                style: TextStyle(
                                  fontSize: width * 0.042,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RobotoMedium',
                                ),
                              ),
                            ),
                            DismissibleTaskItem(
                              tasks: provTask.inProgressTasks,
                              prov: provTask,
                            ),
                            Padding(
                              padding: EdgeInsets.all(width * 0.05),
                              child: Text(
                                'Done Tasks',
                                style: TextStyle(
                                  fontSize: width * 0.042,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'RobotoMedium',
                                ),
                              ),
                            ),
                            DismissibleTaskItem(
                              tasks: provTask.doneTasks,
                              prov: provTask,
                            ),
                          ],
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
