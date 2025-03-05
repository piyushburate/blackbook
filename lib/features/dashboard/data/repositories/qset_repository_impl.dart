import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/features/dashboard/domain/repositories/qset_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../datasources/qset_remote_data_source.dart';

class QsetRepositoryImpl implements QsetRepository {
  final QsetRemoteDataSource qsetRemoteDataSource;

  const QsetRepositoryImpl(this.qsetRemoteDataSource);

  @override
  Future<Either<Failure, Qset>> getQsetFromId(String id) async {
    try {
      final qset = await qsetRemoteDataSource.getQsetFromId(id);
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
      final attemptedQuestion = await qsetRemoteDataSource
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
          await qsetRemoteDataSource.getQsetAttemptedQuestions(authUser, qset);
      return right(attemptedQuestionList);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
