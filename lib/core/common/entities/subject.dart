import 'package:blackbook/core/common/entities/exam.dart';
import 'package:blackbook/core/common/entities/qset.dart';

class Subject {
  final String id;
  final String name;
  final Exam exam;
  final List<Qset> qsets;

  int get chaptersCount => qsets.length;
  int get questionsCount {
    int count = 0;
    for (var qset in qsets) {
      count += qset.questions.length;
    }
    return count;
  }

  const Subject({
    required this.id,
    required this.name,
    required this.exam,
    required this.qsets,
  });
}
