import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/pages/error_page.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:blackbook/core/common/widgets/password_field.dart';
import 'package:blackbook/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../../../core/common/widgets/app_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  AuthUser? authUser;
  bool loading = true;

  final _formKey = GlobalKey<FormState>();
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _conPasswordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() {
    if (!loading) {
      setState(() => loading = true);
    }
    final appUserState = GetIt.instance<AppUserCubit>().state;
    if (appUserState is AppUserAuthorized) {
      final authUser = appUserState.authUser;
      this.authUser = authUser;
    }
    setState(() {
      loading = false;
    });
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!validator.password(value)) {
      return 'Password at least contain one uppercase, lowercase, special character, & number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return AppLoader();
    }
    if (authUser == null) {
      return ErrorPage(
        onRetry: loadData,
        title: 'Error!',
        subtitle: 'User Not Found!',
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 18,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PasswordField(
                  controller: _currentPasswordCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  hintText: 'Current Password',
                ),
                PasswordField(
                  controller: _newPasswordCtrl,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter New Password',
                  validator: (value) {
                    if (value == _currentPasswordCtrl.text.trim()) {
                      return "New password must be different from your current password.";
                    }
                    return validatePassword(value);
                  },
                ),
                PasswordField(
                  controller: _conPasswordCtrl,
                  textInputAction: TextInputAction.done,
                  onSubmit: submitForm,
                  hintText: 'Retype New Password',
                  validator: (value) {
                    if (value != _newPasswordCtrl.text.trim()) {
                      return "Password doesn't match";
                    }
                    return validatePassword(value);
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: AppButton(
            text: 'Change Password',
            trailing: Icon(Icons.check),
            onPressed: submitForm,
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_newPasswordCtrl.text.trim() != _conPasswordCtrl.text.trim()) {
        return;
      }
      EasyLoading.show();
      final isUpdated = await context.read<SettingsCubit>().changePassword(
            currentPassword: _currentPasswordCtrl.text.trim(),
            newPassword: _newPasswordCtrl.text.trim(),
          );
      if (isUpdated) {
        EasyLoading.showSuccess(
          'Password Changed Successfully!',
          dismissOnTap: true,
        );
        // ignore: use_build_context_synchronously
        context.pop();
      }
    }
  }
}
