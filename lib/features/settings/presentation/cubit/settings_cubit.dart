import 'package:blackbook/features/settings/domain/usecases/change_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../domain/usecases/update_personal_details.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UpdatePersonalDetails _updatePersonalDetails;
  final ChangePassword _changePassword;
  SettingsCubit({
    required UpdatePersonalDetails updatePersonalDetails,
    required ChangePassword changePassword,
  })  : _updatePersonalDetails = updatePersonalDetails,
        _changePassword = changePassword,
        super(SettingsInitial());

  Future<bool> updatePersonalDetails({
    required String? firstName,
    required String? lastName,
    required DateTime? birthdate,
    required String? gender,
  }) async {
    bool result = false;
    final response = await _updatePersonalDetails(UpdatePersonalDetailsParams(
      firstName: firstName,
      lastName: lastName,
      birthdate: birthdate,
      gender: gender,
    ));
    response.fold(
      (failure) => EasyLoading.showError(failure.message, dismissOnTap: true),
      (isUpdated) => result = isUpdated,
    );
    return result;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    bool result = false;
    final response = await _changePassword(ChangePasswordParams(
      currentPassword: currentPassword,
      newPassword: newPassword,
    ));
    response.fold(
      (failure) => EasyLoading.showError(failure.message, dismissOnTap: true),
      (isUpdated) => result = isUpdated,
    );
    return result;
  }
}
