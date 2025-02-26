part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedOut extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final AuthSuccess authState;
  User get user => authState.user;

  const AppUserLoggedIn(this.authState);
}

final class AppUserAuthorized extends AppUserState {
  final AuthUser authUser;

  const AppUserAuthorized(this.authUser);
}
