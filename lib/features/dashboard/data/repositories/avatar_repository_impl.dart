import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/features/dashboard/data/datasources/avatar_remote_data_source.dart';
import 'package:blackbook/features/dashboard/domain/repositories/avatar_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

import '../../../../core/error/exceptions.dart';

class AvatarRepositoryImpl implements AvatarRepository {
  final AvatarRemoteDataSource avatarRemoteDataSource;

  AvatarRepositoryImpl(this.avatarRemoteDataSource);

  @override
  Future<Either<Failure, List<Avatar>>> listAvatars() async {
    try {
      final avatars = await avatarRemoteDataSource.listAvatars();
      return right(avatars);
    } on sp.StorageException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> setUserAvatar(Avatar? avatar) async {
    try {
      final response = await avatarRemoteDataSource.setUserAvatar(avatar);
      return right(response);
    } on sp.StorageException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
