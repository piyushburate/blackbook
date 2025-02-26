import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/test.dart';

class TestAttempt {
  final String id;
  final AuthUser user;
  final Test test;
  final int time;

  TestAttempt({
    required this.id,
    required this.user,
    required this.test,
    required this.time,
  });
}
