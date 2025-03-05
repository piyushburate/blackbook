import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/dashboard/domain/repositories/avatar_repository.dart';
import 'package:fpdart/fpdart.dart';

class SetUserAvatar implements UseCase<bool, SetUserAvatarParams> {
  final AvatarRepository avatarRepository;

  const SetUserAvatar(this.avatarRepository);

  @override
  Future<Either<Failure, bool>> call(SetUserAvatarParams params) async {
    return await avatarRepository.setUserAvatar(params.avatar);
  }
}

class SetUserAvatarParams {
  final Avatar? avatar;

  SetUserAvatarParams(this.avatar);
}
