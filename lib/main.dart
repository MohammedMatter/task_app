import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/core/routes/app_routes.dart';
import 'package:task_app/core/services/network_manager.dart';
import 'package:task_app/features/home/data/respositories_impl/notification_repository_impl.dart';
import 'package:task_app/features/home/presentation/view/home_screen.dart';
import 'package:task_app/features/home/presentation/view_models/setting_view_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:task_app/core/services/notification_service.dart';
import 'package:task_app/features/auth/data/datasources/auth_local_data_sources.dart';
import 'package:task_app/features/auth/data/datasources/firebase_auth_data_source.dart';
import 'package:task_app/features/home/data/datasources/task_remote_data_source.dart';
import 'package:task_app/features/auth/data/repositories_impl/auth_repositories_impl.dart';
import 'package:task_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:task_app/features/home/data/respositories_impl/category_repository_impl.dart';
import 'package:task_app/features/home/data/respositories_impl/task_repository_impl.dart';
import 'package:task_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:task_app/features/user/data/repositories_impl/user_repository_impl.dart';
import 'package:task_app/features/home/presentation/view_models/category_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/filter_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/notification_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/search_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/task_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/theme_view_model.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';

import 'package:task_app/features/auth/presentation/view/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_app/features/auth/presentation/view/sign_up_screen.dart';
import 'package:task_app/features/splash/presentation/view/spalsh_screen.dart';
import 'package:task_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await NotificationService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences pref = await SharedPreferences.getInstance();

  runApp(
    MyApp(
      isLoggedIn: pref.getBool('isLogin') ?? false,
    ),
  );
}
// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isLoggedIn;
  MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    log('$isLoggedIn');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryViewModel(
            authRepository: AuthRepositoryImpl(
                FirebaseAuthDataSource(), AuthLocalDataSources()),
            categoryRepository: CategoryRepositoryImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskViewModel(
              notificationRepository: NotificationRepositoryImpl(),
              taskRepository: TaskRepositoryImpl(
                  taskRemoteDataSource: TaskRemoteDataSource()),
              authRepository: AuthRepositoryImpl(
                FirebaseAuthDataSource(),
                AuthLocalDataSources(),
              ),
              userRepository: UserRepositoryImpl(
                  userRemoteDataSource: UserRemoteDataSource())),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationViewModel(
              notificationRepository: NotificationRepositoryImpl(),
              authRepository: AuthRepositoryImpl(
                  FirebaseAuthDataSource(), AuthLocalDataSources())),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(
            networkManager: NetworkManager(),
            taskRepository: TaskRepositoryImpl(
                taskRemoteDataSource: TaskRemoteDataSource()),
            authRepository: AuthRepositoryImpl(
                FirebaseAuthDataSource(), AuthLocalDataSources()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingViewModel(),
        )
      ],
      child: Consumer2<ThemeViewModel, AuthViewModel>(
        builder: (context, provThemeViewModel, provAuthViewModel, child) =>
            MaterialApp(
              
          theme: provThemeViewModel.nightThemeEnabled
              ? ThemeData.dark().copyWith()
              : ThemeData.light().copyWith(
            
                  iconTheme: const IconThemeData(
                      color: Color.fromARGB(255, 14, 113, 179)),
                  elevatedButtonTheme: const ElevatedButtonThemeData(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                         Color.fromARGB(255, 14, 113, 179)     )))),
          debugShowCheckedModeBanner: false,
          initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.signUp: (context) => const SignUpScreen(),
            AppRoutes.signIn: (context) => const SignInScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
