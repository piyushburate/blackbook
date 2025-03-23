import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/utils/duration_extension.dart';

class TestResult {
  final TestAttempt attempt;
  late String timeTaken;
  int totalMarks = 0;
  int marksObtained = 0;
  int questionsCorrect = 0;
  int questionsWrong = 0;
  int questionsSkipped = 0;

  double get percentage => (marksObtained / totalMarks) * 100;

  TestResult(this.attempt) {
    timeTaken = Duration(seconds: attempt.time).toHumanReadable();

    for (var question in attempt.test.questions) {
      totalMarks += question.subject.marks;
      final attemptedIndex = attempt.answers.indexWhere(
        (e) => e.question.id == question.id,
      );
      if (attemptedIndex == -1) {
        questionsSkipped++;
        continue;
      }
      final attemptedQuestion = attempt.answers[attemptedIndex];
      if (attemptedQuestion.isCorrect()) {
        questionsCorrect++;
        marksObtained += question.subject.marks;
      } else {
        marksObtained -= question.subject.negativeMarks;
        questionsWrong++;
      }
    }
  }
}
