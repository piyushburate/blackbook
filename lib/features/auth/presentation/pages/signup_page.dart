import 'package:blackbook/core/common/widgets/svg_icon.dart';
import 'package:blackbook/core/constants/app_icons.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/core/common/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../../../core/theme/app_theme.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _conPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _conPasswordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!validator.email(value)) return 'Please enter a valid email';

    return null;
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is AuthLoading) {
          EasyLoading.show();
        }
        if (state is AuthSuccessUnverified) {
          context.push('/auth/verify-otp');
        }
        if (state is AuthSuccessVerified) {
          context.go('/dashboard');
        }
        if (state is AuthFailure) {
          EasyLoading.showError(state.message);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Enter your details below to get started',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Gap(24),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    spacing: 14,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        autofocus: true,
                        validator: validateEmail,
                        textInputAction: TextInputAction.next,
                        autofillHints: [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          errorMaxLines: null,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SvgIcon(AppIcons.mail, size: 20),
                          ),
                        ),
                      ),
                      PasswordField(
                        controller: _newPasswordController,
                        validator: validatePassword,
                        textInputAction: TextInputAction.next,
                        hintText: 'Enter New Password',
                      ),
                      PasswordField(
                        controller: _conPasswordController,
                        validator: (value) {
                          if (value != _newPasswordController.text.trim()) {
                            return "Password doesn't match";
                          }
                          return validatePassword(value);
                        },
                        textInputAction: TextInputAction.done,
                        onSubmit: () => submitBtnClick(context),
                        hintText: 'Enter Password Again',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
            child: Column(
              spacing: 12,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'By signing up, you agree to our Terms and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .extension<AppColors>()
                        ?.normalTextColor,
                  ),
                ),
                AppButton(
                  onPressed: () => submitBtnClick(context),
                  text: 'Sign Up',
                  trailing: Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitBtnClick(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignUp(
              email: _emailController.text.trim(),
              password: _conPasswordController.text.trim(),
            ),
          );
    }
  }
}
