import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/features/home/presentation/pages/details_category_screen.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/filter_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/search_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/theme_view_model.dart';

import 'package:task_app/features/home/presentation/views/widgets/circle_avatar.dart';
import 'package:task_app/core/widgets/text_field_style.dart';

// ignore: must_be_immutable
class CategorySelector extends StatelessWidget {
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categorydescriptionController = TextEditingController();
  CategorySelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer5<CategoryViewModel, SearchViewModel, TaskViewModel,
        FilterViewModel, ThemeViewModel>(
      builder: (context, prov, provSearchViewModel, provTaskViewModel,
              provFilterViewModel, provThemeViewModel, child) =>
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SizedBox(
                height: 50,
                child: provFilterViewModel.searchType.name == 'category' &&
                        prov.categories.any(
                          (element) {
                            return element.name?.toUpperCase().trim() ==
                                provSearchViewModel.taskCategory
                                    .toUpperCase()
                                    .trim();
                          },
                        )
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              prov.selectCategory(
                                  provSearchViewModel.taskCategory);

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CategoryDetailsPage(),
                              ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              color: prov.categories
                                  .firstWhereOrNull(
                                    (element) =>
                                        element.name!.toUpperCase().trim() ==
                                        provSearchViewModel.taskCategory
                                            .toUpperCase()
                                            .trim(),
                                  )
                                  ?.color,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Center(
                                    child: Text(
                                  provSearchViewModel.taskCategory.trim(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    : ListView.builder(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index < prov.categories.length) {
                            return GestureDetector(
                              onTap: () {
                                prov.selectedCategory =
                                    prov.categories[index].name;
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryDetailsPage(),
                                ));
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color: prov.categories[index].color,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Center(
                                      child: Text(
                                    prov.categories[index].name!,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            );
                          }
                          if (index == prov.categories.length) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheetMethod(context, prov);
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0.8,
                                      color: Color.fromARGB(255, 14, 113, 179)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Center(
                                      child: Row(
                                    children: [
                                      Icon(Icons.add,
                                          color: Color.fromARGB(
                                              255, 14, 113, 179)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Add Category',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 14, 113, 179)),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                        itemCount: prov.categories.length + 1,
                      )),
          ),
        ],
      ),
    );
  }

  void showModalBottomSheetMethod(
      BuildContext context, CategoryViewModel prov) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Consumer<CategoryViewModel>(
        builder: (context, prov, child) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormFieldStyle(
                          textEditingController: categoryNameController,
                          hint: "Category name ",
                          icon: null,
                        ),
                        TextFormFieldStyle(
                          textEditingController: categorydescriptionController,
                          hint: "Category description ",
                          icon: null,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Select Color'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 25),
                        CircleAvatarStyle(
                          radius: 15,
                          method: () => prov.selectColor(Colors.red),
                          isSelected: prov.selectedColor == Colors.red,
                          color: Colors.red,
                        ),
                        CircleAvatarStyle(
                          radius: 15,
                          method: () => prov.selectColor(Colors.green),
                          isSelected: prov.selectedColor == Colors.green,
                          color: Colors.green,
                        ),
                        CircleAvatarStyle(
                          radius: 15,
                          method: () => prov.selectColor(Colors.blue),
                          isSelected: prov.selectedColor == Colors.blue,
                          color: Colors.blue,
                        ),
                        CircleAvatarStyle(
                          radius: 15,
                          method: () => prov.selectColor(Colors.orange),
                          isSelected: prov.selectedColor == Colors.orange,
                          color: Colors.orange,
                        ),
                        CircleAvatarStyle(
                          radius: 15,
                          method: () => prov.selectColor(Colors.purple),
                          isSelected: prov.selectedColor == Colors.purple,
                          color: Colors.purple,
                        ),
                        CircleAvatarStyle(
                          radius: 15,
                          method: () => prov.selectColor(
                              const Color.fromARGB(255, 11, 65, 39)),
                          isSelected: prov.selectedColor ==
                              const Color.fromARGB(255, 11, 65, 39),
                          color: const Color.fromARGB(255, 11, 65, 39),
                        ),
                        const SizedBox(width: 25),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: const WidgetStatePropertyAll(
                              Size(double.infinity, 20)),
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          backgroundColor: const WidgetStatePropertyAll(
                              Color.fromARGB(255, 14, 113, 179)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (categoryNameController.text.isEmpty ||
                              categorydescriptionController.text.isEmpty) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Missing Information',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  content: const Text(
                                      'Please enter both category name and description before saving'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Ok',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 14, 113, 179)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (categoryNameController.text.isNotEmpty) {
                            List testList = prov.categories
                                .where((element) =>
                                    element.name!.toUpperCase().trim() ==
                                    categoryNameController.text
                                        .toUpperCase()
                                        .trim())
                                .toList();
                            if (testList.isEmpty) {
                              prov.addCategory(
                                categoryName: categoryNameController.text,
                                color: prov.selectedColor ?? Colors.grey,
                                categoryDescription:
                                    categorydescriptionController.text,
                              );
                              prov.selectColor(null);
                              Navigator.of(context).pop();
                            } else {
                              prov.selectColor(null);
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Duplicate Category',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  content: const Text(
                                      'You already have a category with this name. Please choose a different name'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
