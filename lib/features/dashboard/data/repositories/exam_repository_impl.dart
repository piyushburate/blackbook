import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/features/dashboard/data/datasources/exam_remote_data_source.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:fpdart/fpdart.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSource examRemoteDataSource;

  const ExamRepositoryImpl(this.examRemoteDataSource);

  @override
  Future<Either<Failure, List<Exam>>> listExams() async {
    try {
      final exams = await examRemoteDataSource.listExams();
      return right(exams);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Exam>> selectUserExam(Exam exam) async {
    try {
      final newExam = await examRemoteDataSource.selectUserExam(exam);
      return right(newExam);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Subject>> getSubjectFromId(String id) async {
    try {
      final subject = await examRemoteDataSource.getSubjectFromId(id);
      return right(subject);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Qset>> getQsetFromId(String id) async {
    try {
      final qset = await examRemoteDataSource.getQsetFromId(id);
      return right(qset);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QsetAttemptedQuestion>> saveQsetAttemptedQuestion(
    AuthUser authUser,
    QsetQuestion question,
    QuestionOption option,
    int time,
  ) async {
    try {
      final attemptedQuestion = await examRemoteDataSource
          .saveQsetAttemptedQuestion(authUser, question, option, time);
      return right(attemptedQuestion);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QsetAttemptedQuestion>>>
      getQsetAttemptedQuestions(
    AuthUser authUser,
    Qset qset,
  ) async {
    try {
      final attemptedQuestionList =
          await examRemoteDataSource.getQsetAttemptedQuestions(authUser, qset);
      return right(attemptedQuestionList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
