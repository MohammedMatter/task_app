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
  CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Consumer5<CategoryViewModel, SearchViewModel, TaskViewModel,
        FilterViewModel, ThemeViewModel>(
      builder: (context, prov, provSearchViewModel, provTaskViewModel,
              provFilterViewModel, provThemeViewModel, child) =>
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: SizedBox(
                height: height * 0.06,
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
                                borderRadius:
                                    BorderRadius.circular(width * 0.08),
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.012,
                                ),
                                child: Center(
                                  child: Text(
                                    provSearchViewModel.taskCategory.trim(),
                                    style:
                                        TextStyle(color: Colors.white, fontSize: width * 0.035),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
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
                                  borderRadius:
                                      BorderRadius.circular(width * 0.08),
                                ),
                                color: prov.categories[index].color,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                    vertical: height * 0.012,
                                  ),
                                  child: Center(
                                    child: Text(
                                      prov.categories[index].name!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.035),
                                    ),
                                  ),
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
                                    width: width * 0.002,
                                    color: const Color.fromARGB(
                                        255, 14, 113, 179),
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.08),
                                ),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.025,
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Icon(Icons.add,
                                            color: const Color.fromARGB(
                                                255, 14, 113, 179),
                                            size: width * 0.045),
                                        SizedBox(width: width * 0.01),
                                        Text(
                                          'Add Category',
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 14, 113, 179),
                                              fontSize: width * 0.035),
                                        ),
                                      ],
                                    ),
                                  ),
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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

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
              height: height * 0.35,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(width * 0.03),
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
                    Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Select Color'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: width * 0.05),
                        CircleAvatarStyle(
                          radius: width * 0.04,
                          method: () => prov.selectColor(Colors.red),
                          isSelected: prov.selectedColor == Colors.red,
                          color: Colors.red,
                        ),
                        CircleAvatarStyle(
                          radius: width * 0.04,
                          method: () => prov.selectColor(Colors.green),
                          isSelected: prov.selectedColor == Colors.green,
                          color: Colors.green,
                        ),
                        CircleAvatarStyle(
                          radius: width * 0.04,
                          method: () => prov.selectColor(Colors.blue),
                          isSelected: prov.selectedColor == Colors.blue,
                          color: Colors.blue,
                        ),
                        CircleAvatarStyle(
                          radius: width * 0.04,
                          method: () => prov.selectColor(Colors.orange),
                          isSelected: prov.selectedColor == Colors.orange,
                          color: Colors.orange,
                        ),
                        CircleAvatarStyle(
                          radius: width * 0.04,
                          method: () => prov.selectColor(Colors.purple),
                          isSelected: prov.selectedColor == Colors.purple,
                          color: Colors.purple,
                        ),
                        CircleAvatarStyle(
                          radius: width * 0.04,
                          method: () => prov.selectColor(
                              const Color.fromARGB(255, 11, 65, 39)),
                          isSelected: prov.selectedColor ==
                              const Color.fromARGB(255, 11, 65, 39),
                          color: const Color.fromARGB(255, 11, 65, 39),
                        ),
                        SizedBox(width: width * 0.05),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, height * 0.05)),
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          backgroundColor: const WidgetStatePropertyAll(
                              Color.fromARGB(255, 14, 113, 179)),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(width * 0.04),
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
                                  title: Text(
                                    'Missing Information',
                                    style:
                                        TextStyle(fontSize: width * 0.05),
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
                                  title: Text(
                                    'Duplicate Category',
                                    style:
                                        TextStyle(fontSize: width * 0.05),
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
