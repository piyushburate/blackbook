import 'package:blackbook/core/common/entities/subject.dart';
import 'package:blackbook/core/common/models/exam_model.dart';
import 'package:blackbook/core/common/models/qset_model.dart';

class SubjectModel extends Subject {
  const SubjectModel({
    required super.id,
    required super.name,
    required super.exam,
    required super.qsets,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      exam: ExamModel.fromJson(map['exam'] ?? {}),
      qsets: (map['qsets'] != null)
          ? List.generate(
              map['qsets'].length,
              (index) => QsetModel.fromJson(map['qsets'][index]),
            )
          : [],
    );
  }
}
