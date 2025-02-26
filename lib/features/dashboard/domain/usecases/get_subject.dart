import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSubject implements UseCase<Subject, GetSubjectParams> {
  final ExamRepository examRepository;

  const GetSubject(this.examRepository);

  @override
  Future<Either<Failure, Subject>> call(GetSubjectParams params) async {
    return await examRepository.getSubjectFromId(params.id);
  }
}

class GetSubjectParams {
  final String id;

  const GetSubjectParams(this.id);
}
