part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

sealed class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);
}

final class AuthSuccessUnverified extends AuthSuccess {
  const AuthSuccessUnverified(super.user);
}

final class AuthSuccessVerified extends AuthSuccess {
  const AuthSuccessVerified(super.user);
}

final class AuthSuccessComplete extends AuthSuccess {
  final AuthUser authUser;
  const AuthSuccessComplete(this.authUser) : super(authUser);
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}
