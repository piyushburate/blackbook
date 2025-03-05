import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sp;

abstract interface class AvatarRemoteDataSource {
  Future<List<Avatar>> listAvatars();
  Future<bool> setUserAvatar(Avatar? avatar);
}

class AvatarRemoteDataSourceImpl implements AvatarRemoteDataSource {
  final sp.SupabaseClient supabaseClient;

  const AvatarRemoteDataSourceImpl(this.supabaseClient);

  final String avatarBucket = 'avatars';

  @override
  Future<List<Avatar>> listAvatars() async {
    final files = await supabaseClient.storage.from(avatarBucket).list();
    final List<Avatar> avatars = [];
    for (var file in files) {
      final String publicUrl =
          supabaseClient.storage.from(avatarBucket).getPublicUrl(file.name);
      avatars.add(Avatar(name: file.name, url: publicUrl));
    }

    return avatars;
  }

  @override
  Future<bool> setUserAvatar(Avatar? avatar) async {
    final userId = supabaseClient.auth.currentUser!.id;
    final response = await supabaseClient
        .from('users')
        .update({
          'avatar': avatar?.name,
        })
        .eq('id', userId)
        .select('id')
        .single();
    return response['id'] == userId;
  }
}
