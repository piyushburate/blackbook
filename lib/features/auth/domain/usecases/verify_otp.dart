import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/core/common/entities/user.dart';
import 'package:blackbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyOtp implements UseCase<User, VerifyOtpParams> {
  final AuthRepository authRepository;

  const VerifyOtp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) async {
    return await authRepository.verifyOtp(
      email: params.email,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams {
  final String email;
  final String otp;

  VerifyOtpParams({
    required this.email,
    required this.otp,
  });
}
