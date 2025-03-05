import 'package:blackbook/core/common/entities/user.dart';
import 'package:blackbook/core/common/models/auth_user_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      emailVerified: false,
    );
  }

  factory UserModel.fromModel(Map<String, dynamic> map) {
    final exceptions = ['selected_exam', 'mobile', 'avatar'];
    for (var key in map.keys) {
      if (exceptions.contains(key)) {
        continue;
      }
      if (map[key] == null) {
        return UserModel.fromJson(map);
      }
    }
    return AuthUserModel.fromJson(map);
  }

  UserModel copyWith({
    String? id,
    String? email,
    bool? emailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
