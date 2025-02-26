import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/user.dart';

abstract class AuthUser extends User {
  final String firstName;
  final String lastName;
  final DateTime birthdate;
  final String gender;
  final String educationLevel;
  final List<String> examsPreparing;
  final Exam? selectedExam;
  final String? mobile;

  String get fullName;

  AuthUser({
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
  });
}
