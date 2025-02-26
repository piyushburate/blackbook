import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ExamRepository {
  Future<Either<Failure, List<Exam>>> listExams();
  Future<Either<Failure, Exam>> selectUserExam(Exam exam);
  Future<Either<Failure, Subject>> getSubjectFromId(String id);
  Future<Either<Failure, Qset>> getQsetFromId(String id);
  Future<Either<Failure, QsetAttemptedQuestion>> saveQsetAttemptedQuestion(
    AuthUser authUser,
    QsetQuestion question,
    QuestionOption option,
    int time,
  );
  Future<Either<Failure, List<QsetAttemptedQuestion>>>
      getQsetAttemptedQuestions(
    AuthUser authUser,
    Qset qset,
  );
}
