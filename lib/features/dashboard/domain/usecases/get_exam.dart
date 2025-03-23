import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetExam implements UseCase<Exam, GetExamParams> {
  final ExamRepository examRepository;

  const GetExam(this.examRepository);

  @override
  Future<Either<Failure, Exam>> call(GetExamParams params) async {
    return await examRepository.getExamFromId(params.id);
  }
}

class GetExamParams {
  final String id;

  const GetExamParams(this.id);
}
