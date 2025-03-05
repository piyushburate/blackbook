import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/user.dart';
import 'package:blackbook/core/common/models/auth_user_model.dart';
import 'package:blackbook/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void refreshState() {
    GetIt.instance<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  void updateUser(final AuthSuccess? authState) {
    if (authState == null) {
      emit(AppUserLoggedOut());
    } else {
      if (authState is AuthSuccessComplete) {
        emit(AppUserAuthorized(authState.authUser));
      } else {
        emit(AppUserLoggedIn(authState));
      }
    }
  }

  void updateExam(Exam exam) {
    final currentState = state;
    if (currentState is AppUserAuthorized) {
      emit(
        AppUserAuthorized(
          (currentState.authUser as AuthUserModel).copyWith(selectedExam: exam),
        ),
      );
    }
  }

  Future<void> logOut() async {
    emit(AppUserInitial());
    await GetIt.instance<sp.SupabaseClient>().auth.signOut();
    emit(AppUserLoggedOut());
  }
}
