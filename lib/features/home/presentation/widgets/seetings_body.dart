import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:task_app/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:task_app/features/home/presentation/pages/update_password.dart';
import 'package:task_app/features/home/presentation/view_models/setting_view_model.dart';
import 'package:task_app/features/home/presentation/view_models/theme_view_model.dart';
import 'package:task_app/features/home/presentation/views/widgets/about_app_body.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';
import 'package:task_app/features/home/presentation/views/widgets/bg_profile.dart';
import 'package:task_app/features/home/presentation/views/widgets/list_tile_settings.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer4<UserViewModel, AuthViewModel, SettingViewModel,
        ThemeViewModel>(
      builder: (context, provUserViewMidel, provAuthViewModel,
          provSettingViewModel, provThemeViewModel, child) {
        return Padding(
          padding: EdgeInsets.only(
            left: width * 0.05,
            right: width * 0.05,
            top: height * 0.07,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: width * 0.9,
                  height: height * 0.25,
                  child: Card(
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Spacer(),
                        BgProfile(radius: width * 0.22),
                        Text(
                          provUserViewMidel.user?.name ?? 'user',
                          style: TextStyle(fontSize: width * 0.045),
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          provUserViewMidel.user?.email ?? 'User@gmail.com',
                          style: TextStyle(
                            fontFamily: 'RobotoLight',
                            fontSize: width * 0.035,
                          ),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: width * 0.9,
                  height: height * 0.09,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                    elevation: 8,
                    child: Consumer<ThemeViewModel>(
                      builder: (context, provThemeViewModel, child) => ListTile(
                        leading: Icon(
                          provThemeViewModel.nightThemeEnabled
                              ? Icons.nightlight_outlined
                              : Icons.wb_sunny_outlined,
                          color: Colors.blue,
                          size: width * 0.06,
                        ),
                        title: Text(
                          'Change Theme',
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                        trailing: Switch(
                          activeColor: Colors.blue,
                          value: provThemeViewModel.nightThemeEnabled,
                          onChanged: (value) {
                            provThemeViewModel.switchTheme(value);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  width: width * 0.9,
                  height: !provUserViewMidel.user!.isGoogleSignedIn!
                      ? height * 0.45
                      : height * 0.28,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                    elevation: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (!provUserViewMidel.user!.isGoogleSignedIn!)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const UpdatePassword(),
                              ));
                            },
                            child: ListTileSettings(
                              label: 'Change Password',
                              icon: Icons.lock_outline_rounded,
                            ),
                          ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: height * 0.25,
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(width * 0.04),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Support',
                                        style: TextStyle(
                                          fontSize: width * 0.05,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(height: height * 0.015),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Contact us at: ',
                                              style: TextStyle(
                                                color:
                                                    provThemeViewModel.nightThemeEnabled
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontSize: width * 0.045,
                                                fontFamily: 'RobotoMedium',
                                              ),
                                            ),
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  provSettingViewModel
                                                      .callSupport();
                                                },
                                              text: '+970595541004',
                                              style: TextStyle(
                                                fontSize: width * 0.045,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ListTileSettings(
                            label: 'Contact Us',
                            icon: Icons.call_outlined,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AboutAppPage(),
                            ));
                          },
                          child: ListTileSettings(
                            label: 'About App',
                            icon: Icons.info_outline,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: width * 0.05,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure to logout ? ',
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontFamily: 'RobotoMedium',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                        color: provThemeViewModel
                                                .nightThemeEnabled
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.white),
                                      backgroundColor:
                                          const WidgetStatePropertyAll(
                                              Colors.blue),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(width * 0.03),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.setBool('isLogin', false);
                                      provAuthViewModel.signOut(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignInScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: ListTileSettings(
                            label: 'Log out',
                            icon: Icons.logout,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
