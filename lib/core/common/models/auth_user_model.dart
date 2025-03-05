import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/avatar.dart';
import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/models/avatar_model.dart';
import 'package:blackbook/core/common/models/exam_model.dart';
import 'package:blackbook/core/common/models/user_model.dart';

class AuthUserModel extends UserModel implements AuthUser {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final DateTime birthdate;
  @override
  final String gender;
  @override
  final String educationLevel;
  @override
  final List<String> examsPreparing;
  @override
  final Exam? selectedExam;
  @override
  final String? mobile;
  @override
  final Avatar? avatar;

  @override
  String get fullName => '$firstName $lastName';

  const AuthUserModel({
    required super.id,
    required super.email,
    required super.emailVerified,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.educationLevel,
    required this.examsPreparing,
    this.selectedExam,
    this.mobile,
    this.avatar,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> map) {
    return AuthUserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      emailVerified: false,
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      birthdate: (map['birthdate'] != null)
          ? DateTime.parse(map['birthdate']!).toLocal()
          : DateTime(0),
      gender: map['gender'] ?? '',
      educationLevel: map['current_education'] ?? '',
      examsPreparing:
          ((map['exams_preparing'] ?? []) as List<dynamic>).cast<String>(),
      selectedExam: (map['selected_exam'] != null)
          ? ExamModel.fromJson(map['selected_exam'])
          : null,
      mobile: map['mobile'],
      avatar: (map['avatar'] == null)
          ? null
          : AvatarModel.fromName(map['avatar'].toString()),
    );
  }

  @override
  AuthUserModel copyWith({
    String? id,
    String? email,
    bool? emailVerified,
    String? firstName,
    String? lastName,
    DateTime? birthdate,
    String? gender,
    String? educationLevel,
    List<String>? examsPreparing,
    Exam? selectedExam,
    String? mobile,
    Avatar? avatar,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      educationLevel: educationLevel ?? this.educationLevel,
      examsPreparing: examsPreparing ?? this.examsPreparing,
      selectedExam: selectedExam ?? this.selectedExam,
      mobile: mobile ?? this.mobile,
      avatar: avatar ?? this.avatar,
    );
  }
}
