import 'package:blackbook/core/error/exceptions.dart';
import 'package:blackbook/core/common/models/auth_user_model.dart';
import 'package:blackbook/core/common/models/user_model.dart';
import 'package:google_sign_in_all_platforms/google_sign_in_all_platforms.dart';
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
  Future<UserModel> signInWithGoogle();

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
  final GoogleSignIn googleSignIn;

  const AuthRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.googleSignIn,
  });

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  final String userQuery = "*, selected_exam(id, name)";

  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final data = await supabaseClient
        .from('users')
        .select('email, auth_provider')
        .eq('email', email)
        .limit(1)
        .maybeSingle();
    if (data == null) {
      throw ServerException('Sign up first!');
    }
    if (data['auth_provider'] != 'email') {
      throw 'Email is used with Google SignIn';
    }
    return _getSession(() async {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      final session = response.session;
      if (user == null || session == null) {
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

  @override
  Future<UserModel> signInWithGoogle() async {
    return _getSession(() async {
      await googleSignIn.signOut();
      final creds = await googleSignIn.signIn();
      if (creds == null) throw 'Cancelled Google Sign In';
      final idToken = creds.idToken;
      if (idToken == null) throw 'Something went wrong!';
      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
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
          .maybeSingle();
      if (userData == null) {
        throw 'Already registered!';
      }
      return UserModel.fromModel(userData)
          .copyWith(emailVerified: (user.emailConfirmedAt != null));
    } on AuthException catch (e) {
      if (e.code == 'email_not_confirmed') {
        throw ServerException('Email not confirmed, Sign up again!');
      }
      // Authentication error
      throw ServerException(e.message.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    if (currentUserSession != null) {
      final userData = await supabaseClient
          .from('users')
          .select(userQuery)
          .eq('id', currentUserSession!.user.id);
      return UserModel.fromModel(userData.first).copyWith(
          emailVerified: currentUserSession!.user.emailConfirmedAt != null);
    }
    return null;
  }

  @override
  Future<String> sendOtp(String email) async {
    await supabaseClient.auth.signInWithOtp(email: email);
    return 'The OTP has been sent to the email $email';
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
        throw 'Error creating user!';
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
        throw 'An unexpected error occed!';
      }
      return userModel;
    } else {
      throw 'Login first!';
    }
  }
}
