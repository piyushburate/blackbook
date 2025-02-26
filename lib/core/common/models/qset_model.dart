import 'package:blackbook/core/common/entities/qset.dart';
import 'package:blackbook/core/common/models/question_model.dart';
import 'package:blackbook/core/common/models/subject_model.dart';

class QsetModel extends Qset {
  QsetModel({
    required super.id,
    required super.title,
    required super.subject,
    required super.time,
    required super.marks,
    required super.negativeMarks,
    required super.questions,
  });

  factory QsetModel.fromJson(Map<String, dynamic> map) {
    return QsetModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      time: ((map['time'] ?? 0) as num).toInt(),
      marks: ((map['marks'] ?? 0) as num).toInt(),
      negativeMarks: ((map['negative_marks'] ?? 0) as num).toInt(),
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
