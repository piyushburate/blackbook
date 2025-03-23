import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/entities/test_attempt.dart';

class Test {
  final String id;
  final String title;
  final Exam exam;
  final int totalTime;

  final int totalQuestions;
  final List<TestQuestion> questions;
  final List<TestAttempt> attempts;

  Test({
    required this.id,
    required this.title,
    required this.exam,
    required this.totalTime,
    required this.totalQuestions,
    required this.questions,
    required this.attempts,
  });
}
