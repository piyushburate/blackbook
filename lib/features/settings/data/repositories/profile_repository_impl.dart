import 'package:fpdart/fpdart.dart';
import 'package:blackbook/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepositoryImpl(this.profileRemoteDataSource);

  @override
  Future<Either<Failure, bool>> updatePersonalDetails({
    required String? firstName,
    required String? lastName,
    required DateTime? birthdate,
    required String? gender,
  }) async {
    try {
      final response = await profileRemoteDataSource.updatePersonalDetails(
        firstName: firstName,
        lastName: lastName,
        birthdate: birthdate,
        gender: gender,
      );
      return right(response);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await profileRemoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return right(response);
    } on sp.PostgrestException catch (e) {
      return left(Failure(e.message));
    } on sp.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
