import 'avatar.dart';
import 'exam.dart';
import 'user.dart';

abstract class AuthUser extends User {
  final String firstName;
  final String lastName;
  final DateTime birthdate;
  final String gender;
  final String educationLevel;
  final List<String> examsPreparing;
  final Exam? selectedExam;
  final String? mobile;
  final Avatar? avatar;

  String get fullName;

  AuthUser({
    required super.id,
    required super.email,
    required super.authProvider,
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
}
