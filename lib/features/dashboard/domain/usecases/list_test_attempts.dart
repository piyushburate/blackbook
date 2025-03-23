import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/test_repository.dart';
import 'package:fpdart/fpdart.dart';

class ListTestAttempts
    implements UseCase<List<TestAttempt>, ListTestAttemptsParams> {
  final TestRepository testRepository;

  const ListTestAttempts(this.testRepository);

  @override
  Future<Either<Failure, List<TestAttempt>>> call(
      ListTestAttemptsParams params) async {
    return await testRepository.listAttempts(params.examId);
  }
}

class ListTestAttemptsParams {
  final String examId;

  const ListTestAttemptsParams(this.examId);
}
