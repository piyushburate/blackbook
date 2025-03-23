import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/test_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTestAttempt implements UseCase<TestAttempt, GetTestAttemptParams> {
  final TestRepository testRepository;

  const GetTestAttempt(this.testRepository);

  @override
  Future<Either<Failure, TestAttempt>> call(GetTestAttemptParams params) async {
    return await testRepository.getAttemptFromId(params.id);
  }
}

class GetTestAttemptParams {
  final String id;

  const GetTestAttemptParams(this.id);
}
