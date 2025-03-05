import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blackbook/core/common/entities/user.dart';
import 'package:blackbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    return _getUser(() async {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        throw ServerException('Log in first!');
      }
      return user;
    });
  }

  @override
  Future<Either<Failure, User>> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.logInWithEmailPassword(
          email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
          email: email, password: password),
    );
  }

  Future<Either<Failure, User>> _getUser(
      Future<User> Function() function) async {
    try {
      final user = await function();
      return right(user);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on sp.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp(String email) async {
    try {
      final message = await remoteDataSource.sendOtp(email);
      return right(message);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on sp.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return _getUser(
      () async => await remoteDataSource.verifyOtp(
        email: email,
        otp: otp,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> completeRegistration(
      {required String firstName,
      required String lastName,
      required DateTime birthdate,
      required String gender,
      required String educationLevel,
      required List<String> examsPreparing}) {
    return _getUser(() async => remoteDataSource.completeRegistration(
          firstName: firstName,
          lastName: lastName,
          birthdate: birthdate,
          gender: gender,
          educationLevel: educationLevel,
          examsPreparing: examsPreparing,
        ));
  }
}
