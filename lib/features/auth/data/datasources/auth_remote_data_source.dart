import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/common/models/auth_user_model.dart';
import 'package:blackbook/core/common/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel?> getCurrentUserData();
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
  });
  Future<String> sendOtp(String email);
  Future<UserModel> verifyOtp({
    required String email,
    required String otp,
  });
  Future<UserModel> completeRegistration({
    required String firstName,
    required String lastName,
    required DateTime birthdate,
    required String gender,
    required String educationLevel,
    required List<String> examsPreparing,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  const AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  final String userQuery =
      "*, selected_exam:exams(id, name, subjects(id, name, qsets(id, qset_questions(id))), tests(*, exam:exams(id), test_questions(id)))";

  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final data = await supabaseClient
          .from('users')
          .select('email')
          .eq('email', email)
          .limit(1)
          .maybeSingle();
      if (data == null) {
        throw ServerException('Sign up first!');
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
    return _getSession(() async {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw ServerException('Error signing user!');
      }
      return user;
    });
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getSession(() async {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw ServerException('Error creating user!');
      }
      return user;
    });
  }

  Future<UserModel> _getSession(Future<User> Function() function) async {
    try {
      final user = await function();

      final userData = await supabaseClient
          .from('users')
          .select(userQuery)
          .eq('id', user.id)
          .single();

      return UserModel.fromModel(userData)
          .copyWith(emailVerified: (user.emailConfirmedAt != null));
    } on AuthException catch (e) {
      if (e.code == 'email_not_confirmed') {
        throw ServerException('Email not confirmed, Sign up again!');
      }
      // Authentication error
      throw ServerException(e.message.toString());
    } catch (e) {
      // Other error
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('users')
            .select(userQuery)
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromModel(userData.first).copyWith(
            emailVerified: currentUserSession!.user.emailConfirmedAt != null);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> sendOtp(String email) async {
    try {
      await supabaseClient.auth.signInWithOtp(email: email);
      return 'The OTP has been sent to the email $email';
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return _getSession(() async {
      final response = await supabaseClient.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: otp,
      );
      final user = response.user;
      if (user == null) {
        throw ServerException('Error creating user!');
      }
      return user;
    });
  }

  @override
  Future<UserModel> completeRegistration({
    required String firstName,
    required String lastName,
    required DateTime birthdate,
    required String gender,
    required String educationLevel,
    required List<String> examsPreparing,
  }) async {
    try {
      if (currentUserSession != null) {
        await supabaseClient.from('users').update({
          'first_name': firstName,
          'last_name': lastName,
          'birthdate': birthdate.toUtc().toIso8601String(),
          'gender': gender,
          'current_education': educationLevel,
          'exams_preparing': examsPreparing,
        }).eq(
          'id',
          currentUserSession!.user.id,
        );
        final userModel = await getCurrentUserData();
        if (userModel == null || userModel is! AuthUserModel) {
          throw ServerException('An unexpected error occed!');
        }
        return userModel;
      } else {
        throw ServerException('Login first!');
      }
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
