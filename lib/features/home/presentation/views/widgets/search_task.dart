import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/domain/Entities/search_type.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/filter_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/search_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({
    super.key,
  });

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  late final controllerTask;
  late final controllerCategory;

  @override
  void initState() {
    super.initState();
    final provSearchViewModel =
        Provider.of<SearchViewModel>(context, listen: false);
    controllerTask = TextEditingController(text: provSearchViewModel.taskName);
    controllerCategory =
        TextEditingController(text: provSearchViewModel.taskCategory);
  }

  @override
  void dispose() {
    controllerTask.dispose();
    controllerCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provCategoryViewModel = Provider.of<CategoryViewModel>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer3<FilterViewModel, TaskViewModel, SearchViewModel>(
      builder: (context, provFilter, provTask, provSearch, child) => Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.025)),
                color:
                    const Color.fromARGB(255, 14, 113, 179).withOpacity(0.07),
              ),
              child: Autocomplete<String>(
                fieldViewBuilder:
                    (context, textEditingController, focusNode, onFieldSubmitted) {
                  return TextField(
                    onChanged: (value) {
                      if (provFilter.searchType.name == 'task') {
                        provSearch.setTaskName(value);
                        textEditingController.text = controllerTask.text;
                      }
                      if (provFilter.searchType.name == 'category') {
                        textEditingController.text = controllerCategory.text;
                        provSearch.setTaskCategory(value);
                      }
                    },
                    controller: provFilter.searchType.name == 'task'
                        ? controllerTask
                        : controllerCategory,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: width * 0.02),
                        child: Icon(
                          Icons.search,
                          size: width * 0.06,
                        ),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Search ${provFilter.searchType.name}...',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: height * 0.018,
                        horizontal: width * 0.03,
                      ),
                    ),
                    style: TextStyle(fontSize: width * 0.04),
                  );
                },
                optionsBuilder: (textEditingValue) {
                  provTask.filterTasksSearch.clear();
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable.empty();
                  }
                  if (provFilter.searchType.name == 'category') {
                    return provCategoryViewModel.categories
                        .where(
                          (element) => element.name!
                              .toUpperCase()
                              .trim()
                              .contains(textEditingValue.text.toUpperCase().trim()),
                        )
                        .map((e) => e.name!.trim())
                        .toList();
                  } else {
                    provTask.filterTasksSearch.clear();
                    return provTask.allTasks
                        .where(
                          (element) => element.title
                              .trim()
                              .toUpperCase()
                              .contains(textEditingValue.text.toUpperCase().trim()),
                        )
                        .map((e) => e.title.trim());
                  }
                },
                optionsViewBuilder: (context, onSelected, options) {
                  provTask.filterTasksSearch.clear();
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.025),
                        color: const Color.fromARGB(255, 126, 124, 124),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: height * 0.25,
                          maxWidth: width * 0.75,
                        ),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: options
                              .toSet()
                              .map(
                                (option) => Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            provTask.filterTasksSearch.clear();
                                            if (provFilter.searchType.name ==
                                                'task') {
                                              provSearch.setTaskName(option);
                                              controllerTask.text = option;
                                            }
                                            if (provFilter.searchType.name ==
                                                'category') {
                                              provSearch.setTaskCategory(option);
                                              controllerCategory.text = option;
                                            }
                                            onSelected(option);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(width * 0.02),
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: width * 0.04,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: width * 0.025),
          PopupMenuButton(
            color: const Color.fromARGB(255, 14, 113, 179),
            onSelected: (value) {
              provFilter.setSearchType(value);
            },
            icon: Icon(Icons.tune, size: width * 0.065),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SearchType.task,
                child: Text(
                  SearchType.task.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.035,
                  ),
                ),
              ),
              PopupMenuItem(
                value: SearchType.category,
                child: Text(
                  SearchType.category.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.035,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
