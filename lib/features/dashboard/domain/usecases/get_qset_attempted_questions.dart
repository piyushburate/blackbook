import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetQsetAttemptedQuestions
    implements
        UseCase<List<QsetAttemptedQuestion>, GetQsetAttemptedQuestionsParams> {
  final ExamRepository examRepository;

  const GetQsetAttemptedQuestions(this.examRepository);

  @override
  Future<Either<Failure, List<QsetAttemptedQuestion>>> call(
      GetQsetAttemptedQuestionsParams params) async {
    return await examRepository.getQsetAttemptedQuestions(
      params.authUser,
      params.qset,
    );
  }
}

class GetQsetAttemptedQuestionsParams {
  final AuthUser authUser;
  final Qset qset;

  GetQsetAttemptedQuestionsParams({
    required this.authUser,
    required this.qset,
  });
}
