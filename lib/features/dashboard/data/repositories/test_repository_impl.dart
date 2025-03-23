import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/features/dashboard/data/datasources/test_remote_data_source.dart';
import 'package:blackbook/features/dashboard/domain/repositories/test_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

class TestRepositoryImpl implements TestRepository {
  final TestRemoteDataSource testRemoteDataSource;

  const TestRepositoryImpl(this.testRemoteDataSource);

  @override
  Future<Either<Failure, Test>> getTestFromId(String id) async {
    try {
      final test = await testRemoteDataSource.getTestFromId(id);
      return right(test);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on sp.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TestAttempt>>> listAttempts(String examId) async {
    try {
      final attempts = await testRemoteDataSource.listAttempts(examId);
      return right(attempts);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on sp.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TestAttempt>> getAttemptFromId(String id) async {
    try {
      final attempt = await testRemoteDataSource.getAttemptFromId(id);
      return right(attempt);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on sp.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TestAttempt>> addAttempt({
    required Test test,
    required int time,
    required List<TestAttemptedQuestion> attemptedQuestions,
  }) async {
    try {
      final testAttempt = await testRemoteDataSource.addAttempt(
        test: test,
        time: time,
        attemptedQuestions: attemptedQuestions,
      );
      return right(testAttempt);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on sp.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
