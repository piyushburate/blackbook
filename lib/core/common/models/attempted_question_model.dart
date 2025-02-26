import 'package:blackbook/core/common/entities/attempted_question.dart';
import 'package:blackbook/core/common/entities/question.dart';
import 'package:blackbook/core/common/models/auth_user_model.dart';
import 'package:blackbook/core/common/models/question_model.dart';
import 'package:blackbook/core/common/models/test_attempt_model.dart';

class QsetAttemptedQuestionModel extends QsetAttemptedQuestion {
  QsetAttemptedQuestionModel({
    required super.selectedOption,
    required super.user,
    required super.question,
    required super.time,
  });

  factory QsetAttemptedQuestionModel.fromJson(Map<String, dynamic> map) {
    return QsetAttemptedQuestionModel(
      selectedOption: QuestionOption.fromValue(map['selected_option'] ?? ''),
      user: AuthUserModel.fromJson(map['user'] ?? {}),
      question: QsetQuestionModel.fromJson(map['qset_question'] ?? {}),
      time: ((map['time'] ?? 0) as num).toInt(),
    );
  }
}

class TestAttemptedQuestionModel extends TestAttemptedQuestion {
  TestAttemptedQuestionModel({
    required super.selectedOption,
    required super.testAttempt,
    required super.question,
  });

  factory TestAttemptedQuestionModel.fromJson(Map<String, dynamic> map) {
    return TestAttemptedQuestionModel(
      selectedOption: QuestionOption.fromValue(map['selected_option'] ?? ''),
      testAttempt: TestAttemptModel.fromJson(map['test_attempt'] ?? {}),
      question: TestQuestionModel.fromJson(map['test_question'] ?? {}),
    );
  }
}
