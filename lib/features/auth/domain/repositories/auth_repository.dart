import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> currentUser();
  Future<Either<Failure, User>> logInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, String>> sendOtp(String email);
  Future<Either<Failure, User>> verifyOtp({
    required String email,
    required String otp,
  });
  Future<Either<Failure, User>> completeRegistration({
    required String firstName,
    required String lastName,
    required DateTime birthdate,
    required String gender,
    required String educationLevel,
    required List<String> examsPreparing,
  });
}
