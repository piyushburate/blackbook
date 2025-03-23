import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/test_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddTestAttempt implements UseCase<TestAttempt, AddTestAttemptParams> {
  final TestRepository testRepository;

  const AddTestAttempt(this.testRepository);

  @override
  Future<Either<Failure, TestAttempt>> call(AddTestAttemptParams params) async {
    return await testRepository.addAttempt(
      test: params.test,
      time: params.time,
      attemptedQuestions: params.attemptedQuestions,
    );
  }
}

class AddTestAttemptParams {
  final Test test;
  final int time;
  final List<TestAttemptedQuestion> attemptedQuestions;

  AddTestAttemptParams({
    required this.test,
    required this.time,
    required this.attemptedQuestions,
  });
}
