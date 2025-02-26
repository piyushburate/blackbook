part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;

  AuthSignUp({
    required this.email,
    required this.password,
  });
}

final class AuthLogIn extends AuthEvent {
  final String email;
  final String password;

  AuthLogIn({
    required this.email,
    required this.password,
  });
}

final class AuthSendOtp extends AuthEvent {
  final void Function(String message) onSuccess;

  AuthSendOtp(this.onSuccess);
}

final class AuthVerifyOtp extends AuthEvent {
  final String otp;
  final void Function(String message) onFailure;

  AuthVerifyOtp(this.otp, this.onFailure);
}

final class AuthCompleteRegistration extends AuthEvent {
  final String firstName;
  final String lastName;
  final DateTime birthdate;
  final String gender;
  final String educationLevel;
  final List<String> examsPreparing;
  final void Function(String message) onFailure;

  AuthCompleteRegistration({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.educationLevel,
    required this.examsPreparing,
    required this.onFailure,
  });
}

final class AuthLogOut extends AuthEvent {}

final class AuthIsUserLoggedIn extends AuthEvent {}
