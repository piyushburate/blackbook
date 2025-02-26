import 'package:blackbook/core/error/failures.dart';
import 'package:blackbook/core/usecase/use_case.dart';
import 'package:blackbook/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendOtp implements UseCase<String, SendOtpParams> {
  final AuthRepository authRepository;

  const SendOtp(this.authRepository);

  @override
  Future<Either<Failure, String>> call(SendOtpParams params) async {
    return await authRepository.sendOtp(params.email);
  }
}

class SendOtpParams {
  final String email;

  const SendOtpParams(this.email);
}
