import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/settings/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChangePassword implements UseCase<bool, ChangePasswordParams> {
  final ProfileRepository profileRepository;

  ChangePassword(this.profileRepository);

  @override
  Future<Either<Failure, bool>> call(ChangePasswordParams params) async {
    return await profileRepository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}
