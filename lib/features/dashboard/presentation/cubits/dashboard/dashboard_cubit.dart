import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/usecases/list_avatars.dart';
import 'package:blackbook/features/dashboard/domain/usecases/set_user_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ListAvatars _listAvatars;
  final SetUserAvatar _setUserAvatar;
  DashboardCubit({
    required ListAvatars listAvatars,
    required SetUserAvatar setUserAvatar,
  })  : _listAvatars = listAvatars,
        _setUserAvatar = setUserAvatar,
        super(DashboardInitial());

  Future<List<Avatar>> listAvatars() async {
    List<Avatar> result = [];
    final response = await _listAvatars(NoParams());
    response.fold(
      (failure) => EasyLoading.showError(failure.message),
      (avatars) => result = avatars,
    );
    return result;
  }

  Future<bool> setUserAvatar(Avatar? avatar) async {
    bool result = false;
    final response = await _setUserAvatar(SetUserAvatarParams(avatar));
    response.fold(
      (failure) => EasyLoading.showError(failure.message),
      (isUpdated) => result = isUpdated,
    );
    return result;
  }
}
