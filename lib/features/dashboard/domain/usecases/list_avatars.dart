import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/avatar_repository.dart';
import 'package:fpdart/fpdart.dart';

class ListAvatars implements UseCase<List<Avatar>, NoParams> {
  final AvatarRepository avatarRepository;

  const ListAvatars(this.avatarRepository);

  @override
  Future<Either<Failure, List<Avatar>>> call(NoParams params) async {
    return await avatarRepository.listAvatars();
  }
}
