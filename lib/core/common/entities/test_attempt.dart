import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/test.dart';

class TestAttempt {
  final String id;
  final AuthUser user;
  final Test test;
  final int time;
  final List<TestAttemptedQuestion> answers;

  TestAttempt({
    required this.id,
    required this.user,
    required this.test,
    required this.time,
    required this.answers,
  });
}
