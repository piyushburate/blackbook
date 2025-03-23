import 'package:blackbook/core/common/entities/test.dart';
import 'package:blackbook/core/common/models/exam_model.dart';
import 'package:blackbook/core/common/models/question_model.dart';
import 'package:blackbook/core/common/models/test_attempt_model.dart';

class TestModel extends Test {
  TestModel({
    required super.id,
    required super.title,
    required super.exam,
    required super.totalTime,
    required super.totalQuestions,
    required super.questions,
    required super.attempts,
  });

  factory TestModel.fromJson(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      exam: ExamModel.fromJson(map['exam'] ?? {}),
      totalTime: ((map['total_time'] ?? 0) as num).toInt(),
      totalQuestions: ((map['total_questions'] ?? 0) as num).toInt(),
      questions: (map['test_questions'] != null)
          ? List.generate(
              map['test_questions'].length,
              (index) =>
                  TestQuestionModel.fromJson(map['test_questions'][index]),
            )
          : [],
      attempts: (map['test_attempts'] != null)
          ? List.generate(
              map['test_attempts'].length,
              (index) => TestAttemptModel.fromJson(map['test_attempts'][index]),
            )
          : [],
    );
  }
}
