import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/exam_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetQset implements UseCase<Qset, GetQsetParams> {
  final ExamRepository examRepository;

  const GetQset(this.examRepository);

  @override
  Future<Either<Failure, Qset>> call(GetQsetParams params) async {
    return await examRepository.getQsetFromId(params.id);
  }
}

class GetQsetParams {
  final String id;

  const GetQsetParams(this.id);
}
