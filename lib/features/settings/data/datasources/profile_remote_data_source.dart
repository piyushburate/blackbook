import 'package:blackbook/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ProfileRemoteDataSource {
  Future<bool> updatePersonalDetails({
    required String? firstName,
    required String? lastName,
    required DateTime? birthdate,
    required String? gender,
  });
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  const ProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<bool> updatePersonalDetails({
    required String? firstName,
    required String? lastName,
    required DateTime? birthdate,
    required String? gender,
  }) async {
    final userId = supabaseClient.auth.currentUser!.id;
    final response = await supabaseClient
        .from('users')
        .update({
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (birthdate != null) 'birthdate': birthdate,
          if (gender != null) 'gender': gender,
        })
        .eq('id', userId)
        .select('id')
        .single();
    return response['id'] == userId;
  }

  @override
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (supabaseClient.auth.currentSession == null) {
      throw ServerException('Login First!');
    }

    try {
      final response1 = await supabaseClient.auth.signInWithPassword(
        email: supabaseClient.auth.currentSession!.user.email,
        password: currentPassword,
      );
      if (response1.user == null) {
        throw 'Incorrect Current Password!';
      }
    } catch (e) {
      throw 'Incorrect Current Password';
    }

    final response2 = await supabaseClient.auth
        .updateUser(UserAttributes(password: newPassword));
    return (response2.user != null);
  }
}
