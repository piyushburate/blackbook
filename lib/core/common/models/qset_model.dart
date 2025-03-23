import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/models/question_model.dart';
import 'package:blackbook/core/common/models/subject_model.dart';

class QsetModel extends Qset {
  QsetModel({
    required super.id,
    required super.title,
    required super.subject,
    required super.questions,
  });

  factory QsetModel.fromJson(Map<String, dynamic> map) {
    return QsetModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subject: SubjectModel.fromJson(map['subject'] ?? {}),
      questions: (map['qset_questions'] != null)
          ? List.generate(
              map['qset_questions'].length,
              (index) =>
                  QsetQuestionModel.fromJson(map['qset_questions'][index]),
            )
          : [],
    );
  }
}
