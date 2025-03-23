import 'package:blackbook/core/common/entities/test_attempt.dart';
import 'package:blackbook/core/common/models/attempted_question_model.dart';
import 'package:blackbook/core/common/models/auth_user_model.dart';
import 'package:blackbook/core/common/models/test_model.dart';

class TestAttemptModel extends TestAttempt {
  TestAttemptModel({
    required super.id,
    required super.user,
    required super.test,
    required super.time,
    required super.answers,
  });

  factory TestAttemptModel.fromJson(Map<String, dynamic> map) {
    return TestAttemptModel(
      id: map['id'] ?? '',
      user: AuthUserModel.fromJson(map['user'] ?? {}),
      test: TestModel.fromJson(map['test'] ?? {}),
      time: ((map['time'] ?? 0) as num).toInt(),
      answers: (map['answers'] != null)
          ? List.generate(
              map['answers'].length,
              (index) =>
                  TestAttemptedQuestionModel.fromJson(map['answers'][index]),
            )
          : [],
    );
  }
}
