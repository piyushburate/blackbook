import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/core/common/entities/user.dart';
import 'package:blackbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogIn implements UseCase<User, UserLogInParams> {
  final AuthRepository authRepository;

  const UserLogIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLogInParams params) async {
    return await authRepository.logInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLogInParams {
  final String email;
  final String password;

  UserLogInParams({
    required this.email,
    required this.password,
  });
}
