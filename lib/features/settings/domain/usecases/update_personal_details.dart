import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/settings/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdatePersonalDetails
    implements UseCase<bool, UpdatePersonalDetailsParams> {
  final ProfileRepository profileRepository;

  UpdatePersonalDetails(this.profileRepository);

  @override
  Future<Either<Failure, bool>> call(UpdatePersonalDetailsParams params) async {
    return await profileRepository.updatePersonalDetails(
      firstName: params.firstName,
      lastName: params.lastName,
      birthdate: params.birthdate,
      gender: params.gender,
    );
  }
}

class UpdatePersonalDetailsParams {
  final String? firstName;
  final String? lastName;
  final DateTime? birthdate;
  final String? gender;

  UpdatePersonalDetailsParams({
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
  });
}
