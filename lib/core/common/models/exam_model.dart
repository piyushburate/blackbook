import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/models/subject_model.dart';
import 'package:blackbook/core/common/models/test_model.dart';

class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.name,
    required super.subjects,
    required super.tests,
  });

  factory ExamModel.fromJson(Map<String, dynamic> map) {
    return ExamModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      subjects: (map['subjects'] != null)
          ? List.generate(
              map['subjects'].length,
              (index) => SubjectModel.fromJson(map['subjects'][index]),
            )
          : [],
      tests: (map['tests'] != null)
          ? List.generate(
              map['tests'].length,
              (index) => TestModel.fromJson(map['tests'][index]),
            )
          : [],
    );
  }
}
