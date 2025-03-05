import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../bloc/auth_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/common/widgets/app_button.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  bool showError = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is AuthLoading) {
          EasyLoading.show();
        }
        if (state is AuthInitial) {
          context.go('/auth/login');
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
            appBar: AppBar(automaticallyImplyLeading: false),
            body: Padding(
              padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Verify OTP',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Enter the OTP sent to your email',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Gap(30),
                  Form(
                    key: _formKey,
                    child: Pinput(
                      length: 6,
                      autofocus: true,
                      errorText: showError ? 'Invalid OTP' : null,
                      forceErrorState: showError,
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      defaultPinTheme: _pinTheme(),
                      focusedPinTheme: _pinTheme(Theme.of(context)
                          .extension<AppColors>()!
                          .borderDarkColor),
                      followingPinTheme: _pinTheme(Theme.of(context)
                          .extension<AppColors>()!
                          .borderLightColor),
                      errorPinTheme:
                          _pinTheme(Theme.of(context).colorScheme.error),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OTP';
                        }
                        return null;
                      },
                      onCompleted: (value) => submitBtnClick(context),
                    ),
                  ),
                  const Gap(30),
                  Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 14),
                        text: "Did't receive the code? ",
                        children: [
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthSendOtp((message) {
                                  EasyLoading.showSuccess(message);
                                }));
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
              child: AppButton(
                onPressed: () => submitBtnClick(context),
                text: 'Submit',
                trailing: Icon(Icons.arrow_forward_rounded),
              ),
            )),
      ),
    );
  }

  PinTheme _pinTheme([Color? color]) => PinTheme(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
              width: 1.5,
              color: color ??
                  Theme.of(context).extension<AppColors>()!.borderDarkColor),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.fromLTRB(0, 18, 0, 18),
      );

  void submitBtnClick(BuildContext context) {
    showError = false;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      if (_pinController.text.length == 6) {
        context
            .read<AuthBloc>()
            .add(AuthVerifyOtp(_pinController.text.trim(), (message) {
              EasyLoading.showError(message);
            }));
      } else {
        showError = true;
        setState(() {});
      }
    }
  }
}
