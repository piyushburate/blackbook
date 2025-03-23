import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/test_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTest implements UseCase<Test, GetTestParams> {
  final TestRepository testRepository;

  const GetTest(this.testRepository);

  @override
  Future<Either<Failure, Test>> call(GetTestParams params) async {
    return await testRepository.getTestFromId(params.id);
  }
}

class GetTestParams {
  final String id;

  const GetTestParams(this.id);
}
