import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/widgets/dismissible_task_item.dart';

class TasksPages extends StatelessWidget {
  const TasksPages({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: Text(
            'All Tasks',
            style: TextStyle(
              fontFamily: 'RobotoMedium',
              fontSize: width * 0.05,
            ),
          ),
        ),
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, prov, child) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height * 0.5,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: height * 0.01,
              ),
              child: Column(
                children: [
                  DismissibleTaskItem(
                    prov: prov,
                    tasks: prov.allTasks,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
