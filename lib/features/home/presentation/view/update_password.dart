import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/widgets/text_field_style.dart';
import 'package:task_app/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:task_app/features/user/presentation/view_models/user_view_model.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final prov = Provider.of<AuthViewModel>(context, listen: false);
    prov.isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Password',
          style: TextStyle(
            fontSize: width * 0.05,
            fontFamily: 'RobotoMedium',
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: Consumer2<AuthViewModel, UserViewModel>(
          builder:
              (context, provAuthViewModel, provUserViewMidel, child) =>
                  Padding(
            padding: EdgeInsets.all(width * 0.045),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update your current account password.',
                        style: TextStyle(
                          fontFamily: 'RobotoMedium',
                          fontSize: width * 0.04,
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      TextFormFieldStyle(
                        textEditingController: currentPassword,
                        validator: (value) => provAuthViewModel
                            .validateCurrentUpdatePassword(
                                value!, provUserViewMidel.user!.password),
                        hint: 'Current password',
                        icon: Icon(Icons.lock_open_outlined,
                            size: width * 0.055),
                      ),
                      TextFormFieldStyle(
                        validator: (password) => provAuthViewModel
                            .validateNewUpdatePassword(password!,
                                provUserViewMidel.user!.password!),
                        textEditingController: newPassword,
                        hint: 'New Password',
                        icon: Icon(Icons.lock, size: width * 0.055),
                      ),
                      TextFormFieldStyle(
                        validator: (password) => provAuthViewModel
                            .validateUpdateConfirmdassword(
                                password!, newPassword.text),
                        textEditingController: confirmNewPassword,
                        hint: 'Confirm New Password',
                        icon: Icon(Icons.check_circle_outline,
                            size: width * 0.055),
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        height: height * 0.065,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            backgroundColor: const WidgetStatePropertyAll(
                                Color.fromARGB(255, 14, 113, 179)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            provAuthViewModel.isLoading = true;

                            if (_key.currentState!.validate()) {
                              await provAuthViewModel.updatePassword(
                                confirmNewPassword.text,
                                await provAuthViewModel.authRepository
                                    .getPassword(),
                              );
                              provAuthViewModel.isLoading == false
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Password updated successfully ✅',
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink();

                              Navigator.of(context).pushNamed('/signIn');
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: width * 0.045),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
                provAuthViewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
