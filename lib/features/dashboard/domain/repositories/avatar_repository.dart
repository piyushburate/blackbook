import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AvatarRepository {
  Future<Either<Failure, List<Avatar>>> listAvatars();
  Future<Either<Failure, bool>> setUserAvatar(Avatar? avatar);
}
