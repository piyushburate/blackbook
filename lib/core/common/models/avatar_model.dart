import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarModel extends Avatar {
  AvatarModel({
    required super.name,
    required super.url,
  });

  factory AvatarModel.fromName(String name) {
    return AvatarModel(
      name: name,
      url: GetIt.instance<SupabaseClient>()
          .storage
          .from('avatars')
          .getPublicUrl(name),
    );
  }
}
