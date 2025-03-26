import 'package:blackbook/core/common/widgets/svg_icon.dart';
import 'package:blackbook/core/constants/app_icons.dart';
import 'package:blackbook/core/constants/app_images.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/features/auth/presentation/widgets/google_signin_button.dart';
import 'package:blackbook/core/common/widgets/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../../../core/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
    // if (value.length < 8) {
    //   return 'Password must be at least 8 characters long';
    // }
    // if (!validator.password(value)) {
    //   return 'Password at least contain one uppercase, lowercase, special character, & number';
    // }
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
          context.go('/auth/complete-verification');
        }
        if (state is AuthSuccessComplete) {
          context.go('/dashboard');
        }
        if (state is AuthFailure) {
          EasyLoading.showError(state.message);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  AppImages.onBoardingPage2,
                  height: 220,
                ),
                Gap(12),
                Text(
                  'Log in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    color:
                        Theme.of(context).extension<AppColors>()?.darkTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(24),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: validateEmail,
                        textInputAction: TextInputAction.next,
                        autofillHints: [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SvgIcon(AppIcons.mail, size: 20),
                          ),
                        ),
                      ),
                      PasswordField(
                        controller: _passwordController,
                        validator: validatePassword,
                        textInputAction: TextInputAction.done,
                        onSubmit: () => submitBtnClick(context),
                        hintText: 'Enter Your Password',
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: GestureDetector(
                              // onTap: () => context.push('/auth/reset-password'),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(0),
                      AppButton(
                        onPressed: () => submitBtnClick(context),
                        text: 'Sign In',
                        trailing: Icon(Icons.arrow_forward_rounded),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'By signing in, you agree to our Terms and Privacy Policy.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .extension<AppColors>()
                                ?.normalTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                const Row(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Divider()),
                    Text('OR'),
                    Expanded(child: Divider()),
                  ],
                ),
                const Gap(25),
                GoogleSigninButton(
                  onPressed: () =>
                      context.read<AuthBloc>().add(AuthGoogleSignIn()),
                  text: 'Continue with Google',
                ),
                const Gap(25),
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 14),
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.push('/auth/signup'),
                        ),
                      ],
                    ),
                  ),
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
            AuthLogIn(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }
}
