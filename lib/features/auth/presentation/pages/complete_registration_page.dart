// ignore: unused_import
import 'package:blackbook/core/theme/app_pallete.dart';
import 'package:blackbook/core/common/widgets/app_button.dart';
import 'package:blackbook/core/theme/app_theme.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blackbook/core/common/widgets/input_field.dart';
import 'package:blackbook/features/auth/presentation/widgets/multi_selectable_tile_list.dart';
import 'package:blackbook/features/auth/presentation/widgets/selectable_tile_list.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:regexed_validator/regexed_validator.dart';

class CompleteRegistrationPage extends StatefulWidget {
  const CompleteRegistrationPage({super.key});

  @override
  State<CompleteRegistrationPage> createState() =>
      _CompleteRegistrationPageState();
}

class _CompleteRegistrationPageState extends State<CompleteRegistrationPage> {
  final PageController _pageController = PageController();
  int pageIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? birthdate;
  String? gender;
  int? educationLevel;
  final List<String> educationLevelList = [
    'Secondary School (10th Std / SSC)',
    'Higher Secondary (12th Std / HSC)',
    'Undergraduate (Year 1/2/3/4)',
    'Postgraduate (Master\'s/PhD)',
    'Vocational / Doctorate',
    'Not Applicable',
  ];
  Set<int> examsPreparing = {};
  final List<String> examsList = [
    'JEE Main',
    'JEE Advance',
    'NEET',
    'MHCET',
    'UPSC',
    'MPSC'
  ];
  bool showPageOneError = false;
  bool showPageTwoError = false;
  bool showPageThreeError = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!validator.email(value)) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters long';
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
        if (state is AuthSuccessComplete) {
          context.go('/dashboard');
        }
        if (state is AuthFailure) {
          EasyLoading.showError(state.message);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false),
          body: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                pageIndex = value;
              });
            },
            children: [
              buildPageOne(context),
              buildPageTwo(context),
              buildPageThree(context),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pageIndex > 0)
                  AppButton(
                    onPressed: () => backBtnClick(),
                    text: 'Back',
                    leading: Icon(Icons.arrow_back_rounded),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    foregroundColor:
                        Theme.of(context).extension<AppColors>()?.darkTextColor,
                    borderWidth: 2,
                  ),
                if (pageIndex > 0) Gap(12),
                Expanded(
                  child: AppButton(
                    onPressed: () => submitBtnClick(context),
                    text: (pageIndex < 2) ? 'Next' : 'Submit',
                    trailing: Icon(Icons.arrow_forward_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPageThree(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'What exams are you preparing for?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Select exams',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Gap(30),
          if (showPageThreeError && examsPreparing.isEmpty)
            Text(
              'Please select at least one option',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          MultiSelectableTileList(
            selectedIndexes: examsPreparing,
            items: examsList,
            onChanged: (value) {
              examsPreparing = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildPageTwo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'What is your current educational level?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'Select educational level',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Gap(30),
          if (showPageTwoError && (educationLevel == null))
            Text(
              'Please select an option',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          SelectableTileList(
            initiallySelected: educationLevel,
            items: educationLevelList,
            onChanged: (value) {
              educationLevel = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildPageOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            'This helps us personalize your experience',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Gap(35),
          Form(
            key: _formKey,
            autovalidateMode: showPageOneError
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              spacing: 18,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  spacing: 14,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InputField(
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        hintText: 'First Name',
                        prefixIcon: const Icon(
                          Icons.account_circle_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InputField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        hintText: 'Last Name',
                      ),
                    ),
                  ],
                ),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Your Birthdate',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(Icons.cake_outlined, size: 20),
                    ),
                  ),
                  initialValue: birthdate,
                  canClear: false,
                  hideDefaultSuffixIcon: true,
                  mode: DateTimeFieldPickerMode.date,
                  validator: (value) {
                    if (value == null) return 'Birthdate is required';
                    return null;
                  },
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialPickerDateTime: DateTime(2008),
                  onChanged: (DateTime? value) {
                    birthdate = value;
                    setState(() {});
                  },
                ),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gender is required';
                    }
                    return null;
                  },
                  value: gender,
                  hint: Text('Select your gender'),
                  decoration: InputDecoration(
                    hintText: 'Select your gender',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16),
                      child: Icon(
                        (gender != null)
                            ? (gender == 'male')
                                ? Icons.male_rounded
                                : (gender == 'female')
                                    ? Icons.female_outlined
                                    : Icons.transgender_rounded
                            : Icons.transgender_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) => setState(() => gender = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void submitBtnClick(BuildContext context) {
    if (pageIndex == 0) {
      if (_formKey.currentState?.validate() == false) {
        showPageOneError = true;
        setState(() {});
        return;
      }
    }
    if (pageIndex == 1 && educationLevel == null) {
      showPageTwoError = true;
      setState(() {});
      return;
    }
    if (pageIndex == 2 && examsPreparing.isEmpty) {
      showPageThreeError = true;
      setState(() {});
      return;
    }
    if (pageIndex < 2) {
      setState(() {
        showPageOneError = false;
        showPageTwoError = false;
        showPageThreeError = false;
        _pageController.nextPage(
          duration: Durations.medium4,
          curve: Curves.easeInOut,
        );
      });
    } else {
      final List<String> examsPreparing = List.generate(
        this.examsPreparing.length,
        (index) {
          return examsList[index];
        },
      );
      context.read<AuthBloc>().add(AuthCompleteRegistration(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            birthdate: birthdate!,
            gender: gender!,
            educationLevel: educationLevelList[educationLevel!],
            examsPreparing: examsPreparing,
            onFailure: (message) {
              EasyLoading.showError(message);
            },
          ));
    }
  }

  void backBtnClick() {
    if (pageIndex == 0) {
      return;
    }
    setState(() {
      _pageController.previousPage(
        duration: Durations.medium4,
        curve: Curves.easeInOut,
      );
    });
  }
}
