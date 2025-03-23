import 'package:blackbook/core/common/entities/auth_user.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';

class AttemptedQuestion {
  final QuestionOption selectedOption;

  AttemptedQuestion({
    required this.selectedOption,
  });
}

class QsetAttemptedQuestion extends AttemptedQuestion {
  final AuthUser user;
  final QsetQuestion question;
  final int time;

  QsetAttemptedQuestion({
    required super.selectedOption,
    required this.user,
    required this.question,
    required this.time,
  });
}

class TestAttemptedQuestion extends AttemptedQuestion {
  final TestAttempt testAttempt;
  final TestQuestion question;

  TestAttemptedQuestion({
    required super.selectedOption,
    required this.testAttempt,
    required this.question,
  });

  bool isCorrect() {
    return question.isCorrect(selectedOption);
  }
}
