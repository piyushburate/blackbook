import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/test.dart';

enum QuestionOption {
  A,
  B,
  C,
  D,
  none;

  factory QuestionOption.fromValue(String value) {
    return QuestionOption.values.firstWhere(
      (element) => element.name == value,
      orElse: () => QuestionOption.none,
    );
  }
}

class Question {
  final String id;
  final String title;
  final String? explanation;
  final String _optionA;
  final String _optionB;
  final String _optionC;
  final String _optionD;
  final QuestionOption _answer;

  List<String> get options => [_optionA, _optionB, _optionC, _optionD];

  bool isCorrect(QuestionOption answer) {
    return _answer == answer;
  }

  Question({
    required this.id,
    required this.title,
    required this.explanation,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required QuestionOption answer,
  })  : _optionA = optionA,
        _optionB = optionB,
        _optionC = optionC,
        _optionD = optionD,
        _answer = answer;
}

class QsetQuestion extends Question {
  final Qset qset;
  QsetQuestion({
    required super.id,
    required super.title,
    required super.explanation,
    required super.optionA,
    required super.optionB,
    required super.optionC,
    required super.optionD,
    required super.answer,
    required this.qset,
  });
}

class TestQuestion extends Question {
  final Test test;
  final int marks;
  final int negativeMarks;
  TestQuestion({
    required super.id,
    required super.title,
    required super.explanation,
    required super.optionA,
    required super.optionB,
    required super.optionC,
    required super.optionD,
    required super.answer,
    required this.test,
    required this.marks,
    required this.negativeMarks,
  });
}
