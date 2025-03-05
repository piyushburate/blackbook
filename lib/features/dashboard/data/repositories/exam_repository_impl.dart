import 'package:blackbook/core/common/entities/exam.dart';
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
}
