import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/entities/test.dart';

enum QuestionOption {
  A,
  B,
  C,
  D;

  factory QuestionOption.fromValue(String value) {
    return QuestionOption.values.firstWhere(
      (element) => element.name == value,
      orElse: () => QuestionOption.A,
    );
  }
}

class Question {
  final String id;
  final String title;
  final String? explanation;
  final String? reference;
  final String _optionA;
  final String _optionB;
  final String _optionC;
  final String _optionD;
  final QuestionOption answer;

  List<String> get options => [_optionA, _optionB, _optionC, _optionD];

  bool isCorrect(QuestionOption answer) {
    return this.answer.index == answer.index;
  }

  Question({
    required this.id,
    required this.title,
    required this.explanation,
    required this.reference,
    required this.answer,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
  })  : _optionA = optionA,
        _optionB = optionB,
        _optionC = optionC,
        _optionD = optionD;
}

class QsetQuestion extends Question {
  final Qset qset;
  QsetQuestion({
    required super.id,
    required super.title,
    required super.explanation,
    required super.reference,
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
  final Subject subject;
  TestQuestion({
    required super.id,
    required super.title,
    required super.explanation,
    required super.reference,
    required super.optionA,
    required super.optionB,
    required super.optionC,
    required super.optionD,
    required super.answer,
    required this.test,
    required this.subject,
  });
}
