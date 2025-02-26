import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:fpdart/fpdart.dart';

class SelectExam implements UseCase<Exam, SelectExamParams> {
  final ExamRepository examRepository;

  const SelectExam(this.examRepository);

  @override
  Future<Either<Failure, Exam>> call(SelectExamParams params) async {
    return await examRepository.selectUserExam(params.exam);
  }
}

class SelectExamParams {
  final Exam exam;

  const SelectExamParams(this.exam);
}
