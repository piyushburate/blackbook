import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:fpdart/fpdart.dart';

class ListExams implements UseCase<List<Exam>, NoParams> {
  final ExamRepository examRepository;

  const ListExams(this.examRepository);

  @override
  Future<Either<Failure, List<Exam>>> call(NoParams params) async {
    return await examRepository.listExams();
  }
}
