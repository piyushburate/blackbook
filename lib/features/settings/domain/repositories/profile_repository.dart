import 'package:blackbook/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, bool>> updatePersonalDetails({
    required String? firstName,
    required String? lastName,
    required DateTime? birthdate,
    required String? gender,
  });
  Future<Either<Failure, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
