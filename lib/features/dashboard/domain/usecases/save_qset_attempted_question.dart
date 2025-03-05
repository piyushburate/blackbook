import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/qset_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveQsetAttemptedQuestion
    implements UseCase<QsetAttemptedQuestion, SaveQsetAttemptedQuestionParams> {
  final QsetRepository qsetRepository;

  const SaveQsetAttemptedQuestion(this.qsetRepository);

  @override
  Future<Either<Failure, QsetAttemptedQuestion>> call(
      SaveQsetAttemptedQuestionParams params) async {
    return await qsetRepository.saveQsetAttemptedQuestion(
      params.authUser,
      params.question,
      params.option,
      params.time,
    );
  }
}

class SaveQsetAttemptedQuestionParams {
  final AuthUser authUser;
  final QsetQuestion question;
  final QuestionOption option;
  final int time;

  SaveQsetAttemptedQuestionParams({
    required this.authUser,
    required this.question,
    required this.option,
    required this.time,
  });
}
