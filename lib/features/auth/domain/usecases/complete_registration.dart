import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/core/common/entities/user.dart';
import 'package:blackbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CompleteRegistration
    implements UseCase<User, CompleteRegistrationParams> {
  final AuthRepository authRepository;

  const CompleteRegistration(this.authRepository);

  @override
  Future<Either<Failure, User>> call(CompleteRegistrationParams params) async {
    return await authRepository.completeRegistration(
      firstName: params.firstName,
      lastName: params.lastName,
      birthdate: params.birthdate,
      gender: params.gender,
      educationLevel: params.educationLevel,
      examsPreparing: params.examsPreparing,
    );
  }
}

class CompleteRegistrationParams {
  final String firstName;
  final String lastName;
  final DateTime birthdate;
  final String gender;
  final String educationLevel;
  final List<String> examsPreparing;

  const CompleteRegistrationParams({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.educationLevel,
    required this.examsPreparing,
  });
}
