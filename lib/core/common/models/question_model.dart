import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/models/qset_model.dart';
import 'package:blackbook/core/common/models/test_model.dart';

class QsetQuestionModel extends QsetQuestion {
  QsetQuestionModel({
    required super.id,
    required super.title,
    required super.explanation,
    required super.optionA,
    required super.optionB,
    required super.optionC,
    required super.optionD,
    required super.answer,
    required super.qset,
  });

  factory QsetQuestionModel.fromJson(Map<String, dynamic> map) {
    return QsetQuestionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      qset: QsetModel.fromJson(map['qset'] ?? {}),
      explanation: map['explanation'],
      optionA: map['option_a'] ?? '',
      optionB: map['option_b'] ?? '',
      optionC: map['option_c'] ?? '',
      optionD: map['option_d'] ?? '',
      answer: QuestionOption.fromValue(map['answer'] ?? ''),
    );
  }
}

class TestQuestionModel extends TestQuestion {
  TestQuestionModel({
    required super.id,
    required super.title,
    required super.explanation,
    required super.optionA,
    required super.optionB,
    required super.optionC,
    required super.optionD,
    required super.answer,
    required super.test,
    required super.marks,
    required super.negativeMarks,
  });

  factory TestQuestionModel.fromJson(Map<String, dynamic> map) {
    return TestQuestionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      test: TestModel.fromJson(map['test'] ?? {}),
      explanation: map['explanation'],
      optionA: map['option_a'] ?? '',
      optionB: map['option_b'] ?? '',
      optionC: map['option_c'] ?? '',
      optionD: map['option_d'] ?? '',
      answer: QuestionOption.fromValue(map['answer'] ?? ''),
      marks: ((map['marks'] ?? 0) as num).toInt(),
      negativeMarks: ((map['negative_marks'] ?? 0) as num).toInt(),
    );
  }
}
