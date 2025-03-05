import 'package:blackbook/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/pages/error_page.dart';
import 'package:blackbook/core/common/widgets/app_loader.dart';
import 'package:blackbook/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/input_field.dart';

class EditPersonalDetailsPage extends StatefulWidget {
  const EditPersonalDetailsPage({super.key});

  @override
  State<EditPersonalDetailsPage> createState() =>
      _EditPersonalDetailsPageState();
}

class _EditPersonalDetailsPageState extends State<EditPersonalDetailsPage> {
  AuthUser? authUser;
  bool loading = true;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? birthdate;
  String? gender;

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
      _firstNameController.text = authUser.firstName;
      _lastNameController.text = authUser.lastName;
      birthdate = authUser.birthdate;
      gender = authUser.gender;
    }
    setState(() {
      loading = false;
    });
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
          title: Text('Edit Personal Details'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
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
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: AppButton(
            text: 'Save Details',
            trailing: Icon(Icons.check),
            onPressed: submitForm,
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    String? firstName, lastName, gender;
    DateTime? birthdate;

    firstName = (authUser!.firstName != _firstNameController.text.trim())
        ? _firstNameController.text.trim()
        : null;

    lastName = (authUser!.lastName != _lastNameController.text.trim())
        ? _lastNameController.text.trim()
        : null;

    gender = (authUser!.gender != this.gender) ? this.gender : null;

    birthdate = (authUser!.birthdate != this.birthdate) ? this.birthdate : null;

    if (firstName == null &&
        lastName == null &&
        gender == null &&
        birthdate == null) {
      EasyLoading.showInfo(
        'Change details to update!',
        dismissOnTap: true,
      );
    } else {
      final isUpdated =
          await GetIt.instance<SettingsCubit>().updatePersonalDetails(
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        gender: gender,
      );
      if (isUpdated) {
        EasyLoading.showSuccess(
          'Details Saved Successfully!',
          dismissOnTap: true,
        );
        GetIt.instance<AppUserCubit>().refreshState();
      }
    }
  }
}
