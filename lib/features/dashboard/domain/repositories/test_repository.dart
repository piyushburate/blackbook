import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class TestRepository {
  Future<Either<Failure, Test>> getTestFromId(String id);
  Future<Either<Failure, List<TestAttempt>>> listAttempts(String examId);
  Future<Either<Failure, TestAttempt>> getAttemptFromId(String id);
  Future<Either<Failure, TestAttempt>> addAttempt({
    required Test test,
    required int time,
    required List<TestAttemptedQuestion> attemptedQuestions,
  });
}
