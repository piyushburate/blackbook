import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ExamRepository {
  Future<Either<Failure, List<Exam>>> listExams();
  Future<Either<Failure, Exam>> selectUserExam(Exam exam);
  Future<Either<Failure, Subject>> getSubjectFromId(String id);
}
