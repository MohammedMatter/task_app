import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/routes/app_pages.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/theme_view_model.dart';
import 'package:task_app/features/home/presentation/widgets/custom_bottom_sheet.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';

int? indexGlobal = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? index = 0;
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {

        final provTaskViewModel =
            Provider.of<TaskViewModel>(context, listen: false);
        final provCategoryViewModel =
            Provider.of<CategoryViewModel>(context, listen: false);
        final provNotificationViewModel =
            Provider.of<NotificationViewModel>(context, listen: false);
        final userVM = Provider.of<UserViewModel>(context, listen: false);
        userVM.loadUser();
        provTaskViewModel.fetchData();
        provNotificationViewModel.fetchNotifications();

        provCategoryViewModel.fetchCategories();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provCategoryViewModel = Provider.of<CategoryViewModel>(context);
    double hightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
    
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Consumer2<TaskViewModel, ThemeViewModel>(
            builder: (context, provTasksViewModel, provThemeViewModel, child) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: const Color.fromARGB(0, 212, 12, 12),
              statusBarIconBrightness: provThemeViewModel.nightThemeEnabled
                  ? Brightness.light
                  : Brightness.dark,
            ),
          );
          return Material(
            elevation: 8,
            child: SizedBox(
              height: hightScreen * 0.14,
              child: BottomNavigationBar(
                landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                currentIndex: index!,
                selectedIconTheme: IconThemeData(
                    size: hightScreen * 0.035, color: Colors.blue),
                unselectedIconTheme: IconThemeData(size: hightScreen * 0.03),
                onTap: (value) {
                  if (value == 2) {
                    Navigator.of(context).pushNamed('/Home');
                    provCategoryViewModel.selectCategory(null);
                    customBottomSheet(
                      context,
                      hightScreen,
                      widthScreen,
                      provTasksViewModel,
                      provCategoryViewModel,
                      taskNameController,
                      taskDescriptionController,
                    );
                  } else {
                    setState(() {
                      index = value;
                      indexGlobal = index;
              
                      if (index == 1) {
                        provTasksViewModel.allTasks.clear();
                        provTasksViewModel.addAllTasks(
                          provTasksViewModel.upcomingTasks,
                          provTasksViewModel.inProgressTasks,
                          provTasksViewModel.doneTasks,
                        );
                      }
                    });
                  }
                },
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items:  [
                  const BottomNavigationBarItem(
                      label: 'Home',
                      icon: Icon(
                        Icons.home_outlined,
                      )),
                  const BottomNavigationBarItem(
                    label: 'folder',
                    icon: Icon(
                      Icons.folder,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Add',
                    icon: CircleAvatar(
                      foregroundColor: Colors.white,
                      radius: widthScreen* 0.05,
                      backgroundColor: const Color.fromARGB(255, 14, 113, 179),
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                  const BottomNavigationBarItem(
                    label: 'notifications',
                    icon: Icon(
                      Icons.notifications,
                    ),
                  ),
                  const BottomNavigationBarItem(
                    label: 'settings',
                    icon: Icon(
                      Icons.settings,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      body: SafeArea(
        child: AppPages.bottomNavPages[index!],
      ),
    );
  }
}
